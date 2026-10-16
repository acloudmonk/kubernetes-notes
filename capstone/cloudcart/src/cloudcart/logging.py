import json
import logging
from datetime import datetime, timezone

from opentelemetry import trace


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        document = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }
        span_context = trace.get_current_span().get_span_context()
        if span_context.is_valid:
            document["trace_id"] = trace.format_trace_id(span_context.trace_id)
            document["span_id"] = trace.format_span_id(span_context.span_id)
        for field in ("event_id", "order_id"):
            if hasattr(record, field):
                value = getattr(record, field)
                document[field] = (
                    value
                    if value is None or isinstance(value, (bool, int, float, str))
                    else str(value)
                )
        return json.dumps(document, separators=(",", ":"))


def configure_logging() -> None:
    handler = logging.StreamHandler()
    handler.setFormatter(JsonFormatter())
    logging.basicConfig(level=logging.INFO, handlers=[handler], force=True)
    logging.getLogger("pika").setLevel(logging.WARNING)
