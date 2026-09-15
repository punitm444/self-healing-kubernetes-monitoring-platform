from fastapi import FastAPI, Response
from datetime import datetime, timezone
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import os

app = FastAPI(
    title="Self-Healing Kubernetes Monitoring Platform",
    version="0.2.0"
)

# -----------------------------
# Prometheus Metrics
# -----------------------------

REQUEST_COUNT = Counter(
    "app_requests_total",
    "Total number of HTTP requests"
)

REQUEST_LATENCY = Histogram(
    "app_request_latency_seconds",
    "HTTP request latency in seconds"
)

ERROR_COUNT = Counter(
    "app_errors_total",
    "Total number of application errors"
)


# -----------------------------
# Root Endpoint
# -----------------------------

@app.get("/")
def root():
    REQUEST_COUNT.inc()

    return {
        "application": "Self-Healing Kubernetes Monitoring Platform",
        "version": "0.2.0",
        "status": "running",
        "hostname": os.getenv("HOSTNAME", "local")
    }


# -----------------------------
# Health Check
# -----------------------------

@app.get("/health")
def health():
    REQUEST_COUNT.inc()

    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }


# -----------------------------
# Readiness Check
# -----------------------------

@app.get("/ready")
def ready():
    REQUEST_COUNT.inc()

    return {
        "status": "ready"
    }


# -----------------------------
# Prometheus Metrics
# -----------------------------

@app.get("/metrics")
def metrics():
    return Response(
        content=generate_latest(),
        media_type=CONTENT_TYPE_LATEST
    )


# -----------------------------
# Simulate Load
# -----------------------------

@app.get("/simulate/load")
def simulate_load():
    REQUEST_COUNT.inc()

    start = time.time()

    # Simulate some CPU work
    total = 0

    for i in range(2_000_000):
        total += i * i

    REQUEST_LATENCY.observe(time.time() - start)

    return {
        "status": "load generated",
        "result": total
    }


# -----------------------------
# Simulate Application Error
# -----------------------------

@app.get("/simulate/error")
def simulate_error():
    REQUEST_COUNT.inc()
    ERROR_COUNT.inc()

    return Response(
        content='{"status":"error","message":"Simulated application failure"}',
        status_code=500,
        media_type="application/json"
    )