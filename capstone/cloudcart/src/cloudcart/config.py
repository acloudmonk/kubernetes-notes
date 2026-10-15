from dataclasses import dataclass
import os

from psycopg.conninfo import make_conninfo


@dataclass(frozen=True)
class Settings:
    database_dsn: str
    amqp_host: str
    amqp_port: int
    amqp_user: str
    amqp_password: str
    relay_interval_seconds: float

    @classmethod
    def from_environment(cls) -> "Settings":
        return cls(
            database_dsn=make_conninfo(
                host=os.environ.get("DATABASE_HOST", "127.0.0.1"),
                port=os.environ.get("DATABASE_PORT", "5432"),
                dbname=os.environ.get("DATABASE_NAME", "cloudcart"),
                user=os.environ.get("DATABASE_USER", "cloudcart"),
                password=os.environ.get("DATABASE_PASSWORD", ""),
            ),
            amqp_host=os.environ.get("AMQP_HOST", "127.0.0.1"),
            amqp_port=int(os.environ.get("AMQP_PORT", "5672")),
            amqp_user=os.environ.get("AMQP_USER", "cloudcart"),
            amqp_password=os.environ.get("AMQP_PASSWORD", ""),
            relay_interval_seconds=float(os.environ.get("RELAY_INTERVAL_SECONDS", "1")),
        )
