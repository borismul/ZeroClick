"""Unit tests for routes/stats.py - Stats and export endpoints.

Tests verify:
- GET /stats - get statistics
- POST /export - export to Google Sheets
- GET /audi/compare - compare odometer
- GET /audi/odometer-now - get current odometer
- GET /audi/check-trip - check stale trips
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """Create test client with mocked auth."""
    with patch("auth.dependencies.AUTH_ENABLED", False):
        from main import app
        return TestClient(app)


@pytest.fixture
def mock_export_service():
    """Mock export service for endpoint testing."""
    with patch("routes.stats.export_service") as mock:
        yield mock


@pytest.fixture
def mock_webhook_service():
    """Mock webhook service for endpoint testing."""
    with patch("routes.stats.webhook_service") as mock:
        yield mock


class TestGetStats:
    """Tests for GET /stats endpoint."""

    def test_get_stats_success(self, client, mock_export_service):
        """GET /stats returns statistics."""
        mock_export_service.get_stats.return_value = {
            "total_km": 500.0,
            "business_km": 350.0,
            "private_km": 150.0,
            "trip_count": 25,
        }

        response = client.get("/stats", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        data = response.json()
        assert data["total_km"] == 500.0
        assert data["trip_count"] == 25

    def test_get_stats_with_filters(self, client, mock_export_service):
        """GET /stats passes filter parameters."""
        mock_export_service.get_stats.return_value = {
            "total_km": 100.0,
            "business_km": 80.0,
            "private_km": 20.0,
            "trip_count": 5,
        }

        response = client.get(
            "/stats?year=2024&month=1&car_id=car-123",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_export_service.get_stats.assert_called_once_with(
            "test@example.com", 2024, 1, "car-123"
        )

    def test_get_stats_requires_auth(self, client, mock_export_service):
        """GET /stats requires authentication."""
        response = client.get("/stats")

        assert response.status_code == 401


class TestExportToSheet:
    """Tests for POST /export endpoint."""

    def test_export_success(self, client, mock_export_service):
        """POST /export exports to Google Sheets."""
        mock_export_service.export_to_sheets.return_value = {
            "status": "exported",
            "rows": 50,
        }

        response = client.post(
            "/export",
            json={"spreadsheet_id": "test-spreadsheet-123"},
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "exported"
        assert data["rows"] == 50

    def test_export_with_all_options(self, client, mock_export_service):
        """POST /export passes all options to service."""
        mock_export_service.export_to_sheets.return_value = {
            "status": "exported",
            "rows": 25,
            "separate_sheets": True,
        }

        response = client.post(
            "/export",
            json={
                "spreadsheet_id": "test-id",
                "year": 2024,
                "month": 1,
                "car_id": "car-123",
                "separate_sheets": True,
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_export_service.export_to_sheets.assert_called_once_with(
            user_id="test@example.com",
            spreadsheet_id="test-id",
            year=2024,
            month=1,
            car_id="car-123",
            separate_sheets=True,
        )

    def test_export_requires_spreadsheet_id(self, client, mock_export_service):
        """POST /export requires spreadsheet_id."""
        response = client.post(
            "/export",
            json={},
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 422


class TestCompareOdometer:
    """Tests for GET /audi/compare endpoint."""

    def test_compare_odometer_success(self, client, mock_export_service):
        """GET /audi/compare returns comparison data."""
        mock_export_service.compare_odometer.return_value = {
            "start_odometer": 10000,
            "trips_timeline": [
                {"trip_id": "trip-1", "cumulative_km": 10015},
                {"trip_id": "trip-2", "cumulative_km": 10040},
            ],
            "comparison": {
                "actual_odometer_km": 10050,
                "calculated_km": 10040,
                "difference_km": 10,
                "status": "ok",
            },
            "warnings": [],
        }

        response = client.get(
            "/audi/compare",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["start_odometer"] == 10000
        assert len(data["trips_timeline"]) == 2
        assert data["comparison"]["status"] == "ok"

    def test_compare_odometer_with_car_filter(self, client, mock_export_service):
        """GET /audi/compare accepts car_id filter."""
        mock_export_service.compare_odometer.return_value = {
            "car_id": "car-123",
            "start_odometer": 20000,
            "trips_timeline": [],
            "comparison": None,
            "warnings": [],
        }

        response = client.get(
            "/audi/compare?car_id=car-123",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_export_service.compare_odometer.assert_called_once_with(
            "test@example.com", "car-123"
        )


class TestGetCurrentOdometer:
    """Tests for GET /audi/odometer-now endpoint."""

    def test_get_current_odometer_success(self, client):
        """GET /audi/odometer-now returns current odometer readings."""
        with patch("database.get_db") as mock_get_db, \
             patch("services.car_service.car_service") as mock_car_service:

            mock_car_service.get_cars_with_credentials.return_value = [
                {"car_id": "car-1", "brand": "audi"},
            ]
            mock_car_service.check_car_driving_status.return_value = {
                "name": "Audi A4",
                "odometer": 50000,
                "state": "parked",
                "is_parked": True,
            }

            mock_car_doc = MagicMock()
            mock_car_doc.exists = True
            mock_car_doc.to_dict.return_value = {"start_odometer": 45000}

            mock_db = MagicMock()
            mock_db.collection.return_value.document.return_value.collection.return_value.document.return_value.get.return_value = mock_car_doc
            mock_get_db.return_value = mock_db

            response = client.get("/audi/odometer-now?user=test@example.com")

            assert response.status_code == 200
            data = response.json()
            assert len(data["cars"]) == 1
            assert data["cars"][0]["current_odometer"] == 50000

    def test_get_current_odometer_no_cars(self, client):
        """GET /audi/odometer-now returns empty for no cars."""
        with patch("services.car_service.car_service") as mock_car_service, \
             patch("database.get_db"):
            mock_car_service.get_cars_with_credentials.return_value = []

            response = client.get("/audi/odometer-now?user=test@example.com")

            assert response.status_code == 200
            assert response.json()["cars"] == []


class TestCheckStaleTtrips:
    """Tests for GET /audi/check-trip endpoint."""

    def test_check_stale_trips_success(self, client, mock_webhook_service):
        """GET /audi/check-trip triggers stale trip check."""
        mock_webhook_service.check_stale_trips.return_value = {
            "checked": True,
            "finalized_trips": ["trip-123"],
        }

        response = client.get("/audi/check-trip")

        assert response.status_code == 200
        data = response.json()
        assert data["checked"] is True
        mock_webhook_service.check_stale_trips.assert_called_once()

    def test_check_stale_trips_no_stale(self, client, mock_webhook_service):
        """GET /audi/check-trip returns empty when no stale trips."""
        mock_webhook_service.check_stale_trips.return_value = {
            "checked": True,
            "finalized_trips": [],
        }

        response = client.get("/audi/check-trip")

        assert response.status_code == 200
        assert response.json()["finalized_trips"] == []
