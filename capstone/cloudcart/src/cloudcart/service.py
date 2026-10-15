import json
from typing import Any
from uuid import UUID, uuid4

import psycopg
from psycopg.rows import dict_row

from cloudcart.domain import OrderLine, request_fingerprint, validate_lines


class ConflictError(Exception):
    pass


class NotFoundError(Exception):
    pass


class CloudCartService:
    def __init__(self, database_url: str):
        self.database_url = database_url

    def ready(self) -> bool:
        try:
            with psycopg.connect(self.database_url, connect_timeout=2) as connection:
                connection.execute("SELECT 1")
            return True
        except psycopg.Error:
            return False

    def list_products(self) -> list[dict[str, Any]]:
        with psycopg.connect(self.database_url, row_factory=dict_row) as connection:
            return list(
                connection.execute(
                    """
                    SELECT p.id, p.sku, p.name, p.price_cents, s.available
                    FROM catalog.products p
                    JOIN inventory.stock s ON s.product_id = p.id
                    ORDER BY p.sku
                    """
                ).fetchall()
            )

    def get_order(self, order_id: UUID) -> dict[str, Any]:
        with psycopg.connect(self.database_url, row_factory=dict_row) as connection:
            order = connection.execute(
                "SELECT id, status, total_cents, created_at FROM ordering.orders WHERE id = %s",
                (order_id,),
            ).fetchone()
            if order is None:
                raise NotFoundError("order not found")
            order["lines"] = list(
                connection.execute(
                    """
                    SELECT product_id, quantity, unit_price_cents
                    FROM ordering.order_lines WHERE order_id = %s ORDER BY product_id
                    """,
                    (order_id,),
                ).fetchall()
            )
            return order

    def create_order(self, idempotency_key: str, requested: list[OrderLine]) -> dict[str, Any]:
        lines = validate_lines(requested)
        fingerprint = request_fingerprint(lines)

        with psycopg.connect(self.database_url, row_factory=dict_row) as connection:
            connection.execute(
                "SELECT pg_advisory_xact_lock(hashtextextended(%s, 0))",
                (idempotency_key,),
            )
            existing = connection.execute(
                "SELECT request_hash, order_id FROM ordering.idempotency_keys WHERE key = %s",
                (idempotency_key,),
            ).fetchone()
            if existing:
                if existing["request_hash"] != fingerprint:
                    raise ConflictError("idempotency key was already used for another request")
                return self.get_order(existing["order_id"])

            product_ids = [line.product_id for line in lines]
            locked = connection.execute(
                """
                SELECT p.id, p.price_cents, s.available
                FROM catalog.products p
                JOIN inventory.stock s ON s.product_id = p.id
                WHERE p.id = ANY(%s) FOR UPDATE OF s
                """,
                (product_ids,),
            ).fetchall()
            by_id = {row["id"]: row for row in locked}
            if len(by_id) != len(lines):
                raise NotFoundError("one or more products do not exist")
            for line in lines:
                if by_id[line.product_id]["available"] < line.quantity:
                    raise ConflictError(f"insufficient stock for product {line.product_id}")

            order_id = uuid4()
            total = sum(by_id[line.product_id]["price_cents"] * line.quantity for line in lines)
            connection.execute(
                "INSERT INTO ordering.orders (id, status, total_cents) VALUES (%s, 'accepted', %s)",
                (order_id, total),
            )
            for line in lines:
                connection.execute(
                    "UPDATE inventory.stock SET available = available - %s WHERE product_id = %s",
                    (line.quantity, line.product_id),
                )
                connection.execute(
                    """
                    INSERT INTO ordering.order_lines
                        (order_id, product_id, quantity, unit_price_cents)
                    VALUES (%s, %s, %s, %s)
                    """,
                    (order_id, line.product_id, line.quantity, by_id[line.product_id]["price_cents"]),
                )
            connection.execute(
                """
                INSERT INTO ordering.idempotency_keys (key, request_hash, order_id)
                VALUES (%s, %s, %s)
                """,
                (idempotency_key, fingerprint, order_id),
            )
            event_id = uuid4()
            payload = {"event_id": str(event_id), "order_id": str(order_id), "total_cents": total}
            connection.execute(
                """
                INSERT INTO messaging.outbox (id, aggregate_id, event_type, payload)
                VALUES (%s, %s, 'order.accepted.v1', %s::jsonb)
                """,
                (event_id, order_id, json.dumps(payload)),
            )
        return self.get_order(order_id)
