# tests/test_product_service.py

import sys
import os
# Agregar la carpeta del servicio al path para poder importar main.py
sys.path.append(os.path.join(os.path.dirname(__file__), "../product-service"))

import pytest
from httpx import AsyncClient
import main  # ahora Python encuentra main.py aunque la carpeta tenga guion

@pytest.mark.asyncio
async def test_health_endpoint():
    async with AsyncClient(app=main.app, base_url="http://test") as client:
        response = await client.get("/health")
    
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "product-service"
