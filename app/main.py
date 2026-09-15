from fastapi import FastAPI
from datetime import datetime, timezone

app = FastAPI(
    title="Self-Healing Kubernetes Monitoring Platform",
    version="0.1.0"
)


@app.get("/")
def root():
    return {
        "application": "Self-Healing Kubernetes Monitoring Platform",
        "version": "0.1.0",
        "status": "running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }