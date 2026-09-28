from fastapi import FastAPI, Request
from kubernetes import client, config
from kubernetes.client.rest import ApiException

app = FastAPI(title="Kubernetes Remediation Service")


@app.get("/")
def root():
    return {
        "service": "Kubernetes Remediation Service",
        "status": "running"
    }


@app.post("/remediate")
async def remediate(request: Request):
    payload = await request.json()

    alerts = payload.get("alerts", [])

    if not alerts:
        return {
            "status": "ignored",
            "message": "No alerts received"
        }

    try:
        config.load_incluster_config()

        apps_api = client.AppsV1Api()

        namespace = "self-healing"
        deployment_name = "fastapi-app"

        apps_api.patch_namespaced_deployment(
            name=deployment_name,
            namespace=namespace,
            body={
                "spec": {
                    "template": {
                        "metadata": {
                            "annotations": {
                                "self-healing/restarted-at": "true"
                            }
                        }
                    }
                }
            }
        )

        return {
            "status": "remediation-triggered",
            "deployment": deployment_name,
            "namespace": namespace
        }

    except ApiException as e:
        return {
            "status": "error",
            "message": str(e)
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }
