# tests/test_product_service.py
import sys
sys.path.append("product-service")  # Agrega la carpeta del microservicio al path

from fastapi.testclient import TestClient
import main

def test_health_endpoint():
    client = TestClient(main.app)
    response = client.get("/health")

    assert response.status_code == 200
    data = response.json()

    assert "status" in data
    assert data["status"] == "healthy"
    assert data["service"] == "product-service"
