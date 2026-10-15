import pika


EVENT_EXCHANGE = "cloudcart.events"
EVENT_QUEUE = "cloudcart.notifications"
DEAD_LETTER_EXCHANGE = "cloudcart.dlx"
DEAD_LETTER_QUEUE = "cloudcart.notifications.dlq"


def open_channel(
    host: str, port: int, user: str, password: str
) -> tuple[pika.BlockingConnection, pika.channel.Channel]:
    parameters = pika.ConnectionParameters(
        host=host,
        port=port,
        virtual_host="/",
        credentials=pika.PlainCredentials(user, password),
    )
    parameters.connection_attempts = 3
    parameters.retry_delay = 2
    parameters.socket_timeout = 5
    parameters.blocked_connection_timeout = 10
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()
    channel.exchange_declare(exchange=EVENT_EXCHANGE, exchange_type="topic", durable=True)
    channel.exchange_declare(exchange=DEAD_LETTER_EXCHANGE, exchange_type="fanout", durable=True)
    channel.queue_declare(
        queue=EVENT_QUEUE,
        durable=True,
        arguments={
            "x-queue-type": "quorum",
            "x-delivery-limit": 5,
            "x-dead-letter-exchange": DEAD_LETTER_EXCHANGE,
        },
    )
    channel.queue_bind(queue=EVENT_QUEUE, exchange=EVENT_EXCHANGE, routing_key="order.accepted.v1")
    channel.queue_declare(queue=DEAD_LETTER_QUEUE, durable=True)
    channel.queue_bind(queue=DEAD_LETTER_QUEUE, exchange=DEAD_LETTER_EXCHANGE)
    return connection, channel
