import json
import logging
import signal
from uuid import UUID

import pika
import psycopg

from cloudcart.config import Settings
from cloudcart.logging import configure_logging
from cloudcart.messaging import EVENT_QUEUE, open_channel


def main() -> None:
    configure_logging()
    logger = logging.getLogger("cloudcart.notification")
    settings = Settings.from_environment()
    connection, channel = open_channel(
        settings.amqp_host,
        settings.amqp_port,
        settings.amqp_user,
        settings.amqp_password,
    )
    channel.basic_qos(prefetch_count=1)

    def stop(*_: object) -> None:
        if channel.is_open:
            channel.stop_consuming()

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    def consume(
        current_channel: pika.channel.Channel,
        method: pika.spec.Basic.Deliver,
        properties: pika.BasicProperties,
        body: bytes,
    ) -> None:
        try:
            payload = json.loads(body)
            event_id = UUID(properties.message_id or payload["event_id"])
            order_id = UUID(payload["order_id"])
            with psycopg.connect(settings.database_dsn) as database:
                inserted = database.execute(
                    """
                    INSERT INTO notification.processed_events (event_id, order_id)
                    VALUES (%s, %s) ON CONFLICT (event_id) DO NOTHING
                    RETURNING event_id
                    """,
                    (event_id, order_id),
                ).fetchone()
            if inserted:
                logger.info(
                    "notification recorded",
                    extra={"event_id": str(event_id), "order_id": str(order_id)},
                )
            else:
                logger.info("duplicate event ignored", extra={"event_id": str(event_id)})
            current_channel.basic_ack(method.delivery_tag)
        except (KeyError, ValueError, json.JSONDecodeError) as error:
            logger.error("invalid event sent to dead-letter queue: %s", error)
            current_channel.basic_reject(method.delivery_tag, requeue=False)
        except psycopg.Error as error:
            logger.warning("database unavailable; event will be retried: %s", error)
            current_channel.basic_nack(method.delivery_tag, requeue=True)

    channel.basic_consume(queue=EVENT_QUEUE, on_message_callback=consume, auto_ack=False)
    try:
        channel.start_consuming()
    finally:
        if connection.is_open:
            connection.close()


if __name__ == "__main__":
    main()
