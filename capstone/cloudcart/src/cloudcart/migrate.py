from pathlib import Path

import psycopg

from cloudcart.config import Settings
from cloudcart.logging import configure_logging


def main() -> None:
    configure_logging()
    migration = Path("/app/migrations/001_initial.sql")
    if not migration.exists():
        migration = Path(__file__).resolve().parents[2] / "migrations" / "001_initial.sql"
    with psycopg.connect(Settings.from_environment().database_dsn) as connection:
        connection.execute(migration.read_text(encoding="utf-8"))


if __name__ == "__main__":
    main()
