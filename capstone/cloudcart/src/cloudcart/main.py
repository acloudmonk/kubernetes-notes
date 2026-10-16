from typing import Protocol
from uuid import UUID

from fastapi import FastAPI, Header, HTTPException, Response, status
from pydantic import BaseModel, Field

from cloudcart.config import Settings
from cloudcart.domain import OrderLine
from cloudcart.logging import configure_logging
from cloudcart.metrics import ORDER_REQUESTS, metrics_response, observe_http
from cloudcart.service import CloudCartService, ConflictError, NotFoundError


class OrderLineRequest(BaseModel):
    product_id: UUID
    quantity: int = Field(gt=0)


class OrderRequest(BaseModel):
    lines: list[OrderLineRequest] = Field(min_length=1)


class Service(Protocol):
    def ready(self) -> bool: ...
    def list_products(self) -> list[dict]: ...
    def get_order(self, order_id: UUID) -> dict: ...
    def create_order(self, idempotency_key: str, requested: list[OrderLine]) -> dict: ...


def create_app(service: Service | None = None) -> FastAPI:
    configure_logging()
    selected = service or CloudCartService(Settings.from_environment().database_dsn)
    application = FastAPI(title="CloudCart API", version="0.1.0")
    application.middleware("http")(observe_http)

    @application.get("/metrics", include_in_schema=False)
    def metrics() -> Response:
        return metrics_response()

    @application.get("/health/live")
    def live() -> dict[str, str]:
        return {"status": "alive"}

    @application.get("/health/ready")
    def ready() -> dict[str, str]:
        if not selected.ready():
            raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail="database unavailable")
        return {"status": "ready"}

    @application.get("/api/catalog/items")
    def products() -> list[dict]:
        return selected.list_products()

    @application.post("/api/orders", status_code=status.HTTP_201_CREATED)
    def create_order(
        request: OrderRequest,
        idempotency_key: str = Header(min_length=8, max_length=128),
    ) -> dict:
        try:
            order = selected.create_order(
                idempotency_key,
                [OrderLine(line.product_id, line.quantity) for line in request.lines],
            )
            ORDER_REQUESTS.labels(result="accepted").inc()
            return order
        except ConflictError as error:
            ORDER_REQUESTS.labels(result="conflict").inc()
            raise HTTPException(status_code=409, detail=str(error)) from error
        except (NotFoundError, ValueError) as error:
            ORDER_REQUESTS.labels(result="invalid").inc()
            raise HTTPException(status_code=422, detail=str(error)) from error

    @application.get("/api/orders/{order_id}")
    def get_order(order_id: UUID) -> dict:
        try:
            return selected.get_order(order_id)
        except NotFoundError as error:
            raise HTTPException(status_code=404, detail=str(error)) from error

    return application


app = create_app()
