"""Unit tests for routes/locations.py - Location management endpoints.

Tests verify:
- GET /locations - list custom locations
- POST /locations - add custom location
- DELETE /locations/{name} - delete custom location
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """Create test client."""
    with patch("auth.dependencies.AUTH_ENABLED", False):
        from main import app
        return TestClient(app)


@pytest.fixture
def mock_location_service():
    """Mock location service."""
    with patch("routes.locations.location_service") as mock:
        yield mock


class TestGetLocations:
    """Tests for GET /locations endpoint."""

    def test_get_locations_returns_list(self, client, mock_location_service):
        """GET /locations returns list of custom locations."""
        mock_location_service.get_locations.return_value = [
            {"name": "Thuis", "lat": 51.9, "lng": 4.5, "is_business": False},
            {"name": "Kantoor", "lat": 51.95, "lng": 4.55, "is_business": True},
        ]

        response = client.get("/locations")

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["name"] == "Thuis"
        assert data[1]["name"] == "Kantoor"

    def test_get_locations_empty(self, client, mock_location_service):
        """GET /locations returns empty list when no locations."""
        mock_location_service.get_locations.return_value = []

        response = client.get("/locations")

        assert response.status_code == 200
        assert response.json() == []


class TestAddLocation:
    """Tests for POST /locations endpoint."""

    def test_add_location_success(self, client, mock_location_service):
        """POST /locations adds a new custom location."""
        mock_location_service.add_location.return_value = {
            "status": "added",
            "name": "Gym",
            "lat": 51.92,
            "lng": 4.52,
        }

        response = client.post(
            "/locations",
            json={"name": "Gym", "lat": 51.92, "lng": 4.52},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "added"
        assert data["name"] == "Gym"
        mock_location_service.add_location.assert_called_once_with("Gym", 51.92, 4.52)

    def test_add_location_requires_name(self, client, mock_location_service):
        """POST /locations requires name field."""
        response = client.post(
            "/locations",
            json={"lat": 51.92, "lng": 4.52},
        )

        assert response.status_code == 422

    def test_add_location_requires_coordinates(self, client, mock_location_service):
        """POST /locations requires lat and lng fields."""
        response = client.post(
            "/locations",
            json={"name": "Test"},
        )

        assert response.status_code == 422


class TestDeleteLocation:
    """Tests for DELETE /locations/{name} endpoint."""

    def test_delete_location_success(self, client, mock_location_service):
        """DELETE /locations/{name} deletes a location."""
        mock_location_service.delete_location.return_value = {
            "status": "deleted",
            "name": "Gym",
        }

        response = client.delete("/locations/Gym")

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "deleted"
        mock_location_service.delete_location.assert_called_once_with("Gym")

    def test_delete_location_url_encoded(self, client, mock_location_service):
        """DELETE /locations/{name} handles URL-encoded names."""
        mock_location_service.delete_location.return_value = {"status": "deleted"}

        # URL encode "My Place"
        response = client.delete("/locations/My%20Place")

        assert response.status_code == 200
        mock_location_service.delete_location.assert_called_once_with("My Place")
