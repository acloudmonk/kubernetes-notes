from dataclasses import dataclass
import hashlib
import json
from typing import Iterable
from uuid import UUID


@dataclass(frozen=True)
class OrderLine:
    product_id: UUID
    quantity: int


def validate_lines(lines: Iterable[OrderLine]) -> list[OrderLine]:
    materialized = list(lines)
    if not materialized:
        raise ValueError("an order requires at least one line")
    if any(line.quantity <= 0 for line in materialized):
        raise ValueError("quantity must be greater than zero")
    if len({line.product_id for line in materialized}) != len(materialized):
        raise ValueError("each product may appear only once")
    return materialized


def request_fingerprint(lines: Iterable[OrderLine]) -> str:
    canonical = [
        {"product_id": str(line.product_id), "quantity": line.quantity}
        for line in sorted(lines, key=lambda item: str(item.product_id))
    ]
    encoded = json.dumps(canonical, separators=(",", ":"), sort_keys=True).encode()
    return hashlib.sha256(encoded).hexdigest()
