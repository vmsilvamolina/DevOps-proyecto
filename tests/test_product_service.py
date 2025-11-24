# tests/test_product_service.py

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "../product-service"))

from starlette.testclient import TestClient  # <-- usar Starlette directamente
import main  # main.py del servicio

def test_health_endpoint():
    client = TestClient(main.app)
    response = client.get("/health")
    
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "product-service"
