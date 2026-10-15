import os
from concurrent.futures import ThreadPoolExecutor
from uuid import UUID, uuid4

import pytest

from cloudcart.domain import OrderLine
from cloudcart.service import CloudCartService, ConflictError


DATABASE_URL = os.environ.get("TEST_DATABASE_URL")
pytestmark = pytest.mark.skipif(not DATABASE_URL, reason="set TEST_DATABASE_URL to run database tests")
PRODUCT_ID = UUID("10000000-0000-0000-0000-000000000001")


def test_duplicate_request_has_one_business_effect() -> None:
    service = CloudCartService(DATABASE_URL or "")
    key = f"integration-{uuid4()}"
    first = service.create_order(key, [OrderLine(PRODUCT_ID, 1)])
    replay = service.create_order(key, [OrderLine(PRODUCT_ID, 1)])
    assert first["id"] == replay["id"]


def test_reused_key_with_changed_request_is_rejected() -> None:
    service = CloudCartService(DATABASE_URL or "")
    key = f"integration-{uuid4()}"
    service.create_order(key, [OrderLine(PRODUCT_ID, 1)])
    with pytest.raises(ConflictError):
        service.create_order(key, [OrderLine(PRODUCT_ID, 2)])


def test_concurrent_retries_create_one_order() -> None:
    service = CloudCartService(DATABASE_URL or "")
    key = f"integration-{uuid4()}"

    def submit() -> str:
        return str(service.create_order(key, [OrderLine(PRODUCT_ID, 1)])["id"])

    with ThreadPoolExecutor(max_workers=2) as executor:
        order_ids = list(executor.map(lambda _: submit(), range(2)))

    assert len(set(order_ids)) == 1
