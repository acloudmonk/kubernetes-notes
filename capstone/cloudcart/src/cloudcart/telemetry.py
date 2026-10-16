import os
from typing import Awaitable, Callable

from fastapi import FastAPI, Request, Response
from opentelemetry import propagate, trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.trace import SpanKind, Status, StatusCode


def configure_tracing(application: FastAPI) -> bool:
    """Enable OTLP tracing only when the deployment supplies an endpoint."""
    endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "").rstrip("/")
    if not endpoint:
        return False

    service_name = os.getenv("OTEL_SERVICE_NAME", "cloudcart-api")
    provider = TracerProvider(
        resource=Resource.create(
            {
                "service.name": service_name,
                "service.namespace": "cloudcart",
                "deployment.environment.name": os.getenv(
                    "DEPLOYMENT_ENVIRONMENT", "learning"
                ),
            }
        )
    )
    provider.add_span_processor(
        BatchSpanProcessor(OTLPSpanExporter(endpoint=f"{endpoint}/v1/traces"))
    )
    trace.set_tracer_provider(provider)
    tracer = trace.get_tracer("cloudcart.http")

    @application.middleware("http")
    async def trace_http(
        request: Request,
        call_next: Callable[[Request], Awaitable[Response]],
    ) -> Response:
        parent = propagate.extract(request.headers)
        with tracer.start_as_current_span(
            f"{request.method} {request.url.path}",
            context=parent,
            kind=SpanKind.SERVER,
            attributes={
                "http.request.method": request.method,
                "url.path": request.url.path,
            },
        ) as span:
            try:
                response = await call_next(request)
            except Exception as error:
                span.record_exception(error)
                span.set_status(Status(StatusCode.ERROR, type(error).__name__))
                raise

            route = request.scope.get("route")
            route_template = getattr(route, "path", "unmatched")
            span.update_name(f"{request.method} {route_template}")
            span.set_attribute("http.route", route_template)
            span.set_attribute("http.response.status_code", response.status_code)
            if response.status_code >= 500:
                span.set_status(Status(StatusCode.ERROR))
            return response

    return True
