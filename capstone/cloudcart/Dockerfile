# syntax=docker/dockerfile:1.7
FROM python:3.12.15-slim-trixie AS builder

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN python -m venv /opt/venv
COPY requirements.txt /tmp/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    /opt/venv/bin/pip install --requirement /tmp/requirements.txt

FROM builder AS test

ENV PATH="/opt/venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/src

WORKDIR /app
COPY requirements-dev.txt /tmp/requirements-dev.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    /opt/venv/bin/pip install --requirement /tmp/requirements-dev.txt
COPY src /app/src
COPY tests /app/tests

ENTRYPOINT ["python", "-m", "pytest"]
CMD ["-q"]

FROM python:3.12.15-slim-trixie AS runtime

ENV PATH="/opt/venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/src

RUN groupadd --gid 10001 cloudcart \
    && useradd --uid 10001 --gid cloudcart --no-create-home --shell /usr/sbin/nologin cloudcart

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY --chown=10001:10001 src /app/src
COPY --chown=10001:10001 migrations /app/migrations

USER 10001:10001
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health/live', timeout=2)"]

ENTRYPOINT ["uvicorn"]
CMD ["cloudcart.main:app", "--host=0.0.0.0", "--port=8080"]
