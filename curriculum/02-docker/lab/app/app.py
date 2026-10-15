import os
import socket

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(service="docker-module-api", version="1.0")


@app.get("/healthz")
def health():
    return jsonify(status="ok")


@app.get("/dependency")
def dependency():
    host = os.getenv("DATABASE_HOST", "db")
    port = int(os.getenv("DATABASE_PORT", "5432"))
    try:
        with socket.create_connection((host, port), timeout=2):
            return jsonify(database=f"{host}:{port}", reachable=True)
    except OSError as error:
        return jsonify(database=f"{host}:{port}", reachable=False, error=str(error)), 503
