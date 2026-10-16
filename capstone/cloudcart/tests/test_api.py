from uuid import UUID

from cloudcart.main import create_app
from cloudcart.metrics import HTTP_REQUESTS, ORDER_REQUESTS, metrics_response
from cloudcart.service import ConflictError, NotFoundError


ORDER_ID = UUID("20000000-0000-0000-0000-000000000001")
PRODUCT_ID = UUID("10000000-0000-0000-0000-000000000001")


class FakeService:
    def ready(self) -> bool:
        return True

    def list_products(self) -> list[dict]:
        return [{"id": str(PRODUCT_ID), "sku": "MUG-001", "available": 20}]

    def get_order(self, order_id: UUID) -> dict:
        if order_id != ORDER_ID:
            raise NotFoundError("order not found")
        return {"id": str(ORDER_ID), "status": "accepted", "total_cents": 1299, "lines": []}

    def create_order(self, idempotency_key: str, requested: list) -> dict:
        if idempotency_key == "conflict-key":
            raise ConflictError("duplicate")
        return self.get_order(ORDER_ID)


def test_health_contract_is_published() -> None:
    schema = create_app(FakeService()).openapi()
    assert schema["paths"]["/health/live"]["get"]["responses"]["200"]
    assert schema["paths"]["/health/ready"]["get"]["responses"]["200"]


def test_create_order_requires_idempotency_header() -> None:
    operation = create_app(FakeService()).openapi()["paths"]["/api/orders"]["post"]
    header = next(parameter for parameter in operation["parameters"] if parameter["in"] == "header")
    assert header["name"] == "idempotency-key"
    assert header["required"] is True


def test_create_order_contract_returns_created() -> None:
    operation = create_app(FakeService()).openapi()["paths"]["/api/orders"]["post"]
    assert "201" in operation["responses"]
    assert operation["requestBody"]["required"] is True


def test_metrics_use_route_templates_instead_of_resource_ids() -> None:
    HTTP_REQUESTS.labels(
        method="GET",
        route="/api/orders/{order_id}",
        status_code="200",
    ).inc()
    metrics = metrics_response().body.decode()

    assert "cloudcart_http_requests_total" in metrics
    assert 'route="/api/orders/{order_id}"' in metrics
    assert str(ORDER_ID) not in metrics


def test_order_metric_uses_a_bounded_result_label() -> None:
    ORDER_REQUESTS.labels(result="accepted").inc()
    metrics = metrics_response().body.decode()
    assert 'cloudcart_order_requests_total{result="accepted"}' in metrics
