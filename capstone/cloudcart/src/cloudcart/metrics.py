from time import perf_counter
from typing import Awaitable, Callable

from fastapi import Request, Response
from opentelemetry import trace
from prometheus_client import (
    Counter,
    Gauge,
    Histogram,
    REGISTRY,
)
from prometheus_client.openmetrics.exposition import CONTENT_TYPE_LATEST, generate_latest


HTTP_REQUESTS = Counter(
    "cloudcart_http_requests_total",
    "HTTP requests completed by the CloudCart API.",
    ("method", "route", "status_code"),
)
HTTP_DURATION = Histogram(
    "cloudcart_http_request_duration_seconds",
    "CloudCart API HTTP request duration.",
    ("method", "route"),
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5),
)
HTTP_IN_PROGRESS = Gauge(
    "cloudcart_http_requests_in_progress",
    "CloudCart API HTTP requests currently executing.",
    ("method",),
)
ORDER_REQUESTS = Counter(
    "cloudcart_order_requests_total",
    "Order requests by bounded application outcome.",
    ("result",),
)


async def observe_http(
    request: Request,
    call_next: Callable[[Request], Awaitable[Response]],
) -> Response:
    if request.url.path == "/metrics":
        return await call_next(request)

    method = request.method
    status_code = 500
    started = perf_counter()
    HTTP_IN_PROGRESS.labels(method=method).inc()
    try:
        response = await call_next(request)
        status_code = response.status_code
        return response
    finally:
        route = request.scope.get("route")
        route_template = getattr(route, "path", "unmatched")
        HTTP_IN_PROGRESS.labels(method=method).dec()
        HTTP_REQUESTS.labels(
            method=method,
            route=route_template,
            status_code=str(status_code),
        ).inc()
        span_context = trace.get_current_span().get_span_context()
        exemplar = None
        if span_context.is_valid and span_context.trace_flags.sampled:
            exemplar = {"trace_id": trace.format_trace_id(span_context.trace_id)}
        HTTP_DURATION.labels(method=method, route=route_template).observe(
            perf_counter() - started,
            exemplar=exemplar,
        )


def metrics_response() -> Response:
    return Response(
        content=generate_latest(REGISTRY),
        headers={"Content-Type": CONTENT_TYPE_LATEST},
    )
