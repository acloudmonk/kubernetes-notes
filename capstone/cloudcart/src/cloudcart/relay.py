import json
import logging
import signal
import time

import pika
import psycopg
from psycopg.rows import dict_row

from cloudcart.config import Settings
from cloudcart.logging import configure_logging
from cloudcart.messaging import EVENT_EXCHANGE, open_channel


running = True


def stop(*_: object) -> None:
    global running
    running = False


def main() -> None:
    configure_logging()
    logger = logging.getLogger("cloudcart.relay")
    settings = Settings.from_environment()
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    while running:
        connection = None
        try:
            connection, channel = open_channel(
                settings.amqp_host,
                settings.amqp_port,
                settings.amqp_user,
                settings.amqp_password,
            )
            channel.confirm_delivery()
            while running and connection.is_open:
                with psycopg.connect(settings.database_dsn, row_factory=dict_row) as database:
                    event = database.execute(
                        """
                        SELECT id, event_type, payload FROM messaging.outbox
                        WHERE published_at IS NULL ORDER BY created_at
                        FOR UPDATE SKIP LOCKED LIMIT 1
                        """
                    ).fetchone()
                    if event is not None:
                        channel.basic_publish(
                            exchange=EVENT_EXCHANGE,
                            routing_key=event["event_type"],
                            body=json.dumps(event["payload"]).encode(),
                            properties=pika.BasicProperties(
                                delivery_mode=pika.DeliveryMode.Persistent,
                                content_type="application/json",
                                message_id=str(event["id"]),
                                type=event["event_type"],
                            ),
                            mandatory=True,
                        )
                        database.execute(
                            "UPDATE messaging.outbox SET published_at = now() WHERE id = %s",
                            (event["id"],),
                        )
                        logger.info(
                            "outbox event published", extra={"event_id": str(event["id"])}
                        )
                if event is None:
                    time.sleep(settings.relay_interval_seconds)
        except (pika.exceptions.AMQPError, psycopg.Error) as error:
            logger.warning("relay dependency unavailable: %s", error)
            time.sleep(2)
        finally:
            if connection and connection.is_open:
                connection.close()


if __name__ == "__main__":
    main()
