import json
import logging
from uuid import UUID

from cloudcart.logging import JsonFormatter
from cloudcart.main import create_app


class ReadyService:
    def ready(self) -> bool:
        return True

    def list_products(self) -> list[dict]:
        return []

    def get_order(self, order_id):
        return {}

    def create_order(self, idempotency_key, requested):
        return {}


def test_json_log_without_active_span_omits_correlation_ids() -> None:
    record = logging.LogRecord("test", logging.INFO, __file__, 1, "hello", (), None)
    record.order_id = UUID("20000000-0000-0000-0000-000000000001")
    document = json.loads(JsonFormatter().format(record))

    assert document["message"] == "hello"
    assert document["order_id"] == "20000000-0000-0000-0000-000000000001"
    assert "trace_id" not in document
    assert "span_id" not in document


def test_tracing_is_disabled_without_an_export_endpoint(monkeypatch) -> None:
    monkeypatch.delenv("OTEL_EXPORTER_OTLP_ENDPOINT", raising=False)

    application = create_app(ReadyService())

    assert application.title == "CloudCart API"
