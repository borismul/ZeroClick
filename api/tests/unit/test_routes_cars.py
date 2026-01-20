"""Unit tests for routes/cars.py - Car management endpoints.

Tests verify:
- GET /cars - list cars
- POST /cars - create car
- GET /cars/{car_id} - get single car
- PATCH /cars/{car_id} - update car
- DELETE /cars/{car_id} - delete car
- PUT /cars/{car_id}/credentials - save credentials
- GET /cars/{car_id}/credentials - get credentials status
- DELETE /cars/{car_id}/credentials - delete credentials
- GET /cars/{car_id}/stats - get car statistics
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
def mock_car_service():
    """Mock car service for endpoint testing."""
    with patch("routes.cars.car_service") as mock:
        yield mock


class TestListCars:
    """Tests for GET /cars endpoint."""

    def test_list_cars_returns_array(self, client, mock_car_service):
        """GET /cars returns list of user's cars."""
        mock_car_service.get_cars.return_value = [
            {
                "id": "car-1",
                "name": "Audi A4",
                "brand": "audi",
                "color": "#000000",
            },
            {
                "id": "car-2",
                "name": "Tesla Model 3",
                "brand": "tesla",
                "color": "#FF0000",
            },
        ]

        response = client.get("/cars", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["name"] == "Audi A4"
        assert data[1]["name"] == "Tesla Model 3"

    def test_list_cars_empty(self, client, mock_car_service):
        """GET /cars returns empty list when no cars."""
        mock_car_service.get_cars.return_value = []

        response = client.get("/cars", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        assert response.json() == []

    def test_list_cars_requires_auth(self, client, mock_car_service):
        """GET /cars requires authentication."""
        response = client.get("/cars")

        assert response.status_code == 401


class TestCreateCar:
    """Tests for POST /cars endpoint."""

    def test_create_car_success(self, client, mock_car_service):
        """POST /cars creates a new car."""
        mock_car_service.create_car.return_value = {
            "id": "new-car-123",
            "name": "VW Golf",
            "brand": "volkswagen",
            "color": "#0000FF",
        }

        response = client.post(
            "/cars",
            json={
                "name": "VW Golf",
                "brand": "volkswagen",
                "color": "#0000FF",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "new-car-123"
        assert data["name"] == "VW Golf"

    def test_create_car_with_start_odometer(self, client, mock_car_service):
        """POST /cars accepts start_odometer field."""
        mock_car_service.create_car.return_value = {
            "id": "car-456",
            "start_odometer": 50000,
        }

        response = client.post(
            "/cars",
            json={
                "name": "Audi Q7",
                "brand": "audi",
                "start_odometer": 50000,
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_car_service.create_car.assert_called_once()
        call_kwargs = mock_car_service.create_car.call_args[1]
        assert call_kwargs["start_odometer"] == 50000


class TestGetCar:
    """Tests for GET /cars/{car_id} endpoint."""

    def test_get_car_success(self, client, mock_car_service):
        """GET /cars/{car_id} returns car details."""
        mock_car_service.get_car.return_value = {
            "id": "car-123",
            "name": "Audi A4",
            "brand": "audi",
            "color": "#000000",
            "start_odometer": 10000,
        }

        response = client.get("/cars/car-123", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "car-123"
        assert data["name"] == "Audi A4"

    def test_get_car_not_found(self, client, mock_car_service):
        """GET /cars/{car_id} returns 404 for nonexistent car."""
        mock_car_service.get_car.return_value = None

        response = client.get(
            "/cars/nonexistent-car",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 404


class TestUpdateCar:
    """Tests for PATCH /cars/{car_id} endpoint."""

    def test_update_car_success(self, client, mock_car_service):
        """PATCH /cars/{car_id} updates car fields."""
        mock_car_service.update_car.return_value = {
            "id": "car-123",
            "name": "Audi A4 Avant",
            "color": "#111111",
        }

        response = client.patch(
            "/cars/car-123",
            json={"name": "Audi A4 Avant", "color": "#111111"},
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Audi A4 Avant"

    def test_update_car_partial(self, client, mock_car_service):
        """PATCH /cars/{car_id} only updates provided fields."""
        mock_car_service.update_car.return_value = {"id": "car-123", "color": "#222222"}

        response = client.patch(
            "/cars/car-123",
            json={"color": "#222222"},
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200

    def test_update_car_not_found(self, client, mock_car_service):
        """PATCH /cars/{car_id} returns 404 for nonexistent car."""
        mock_car_service.update_car.return_value = None

        response = client.patch(
            "/cars/nonexistent-car",
            json={"name": "Won't work"},
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 404


class TestDeleteCar:
    """Tests for DELETE /cars/{car_id} endpoint."""

    def test_delete_car_success(self, client, mock_car_service):
        """DELETE /cars/{car_id} deletes car."""
        mock_car_service.delete_car.return_value = {"status": "deleted"}

        response = client.delete(
            "/cars/car-123",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200

    def test_delete_car_not_found(self, client, mock_car_service):
        """DELETE /cars/{car_id} returns 404 for nonexistent car."""
        mock_car_service.delete_car.return_value = None

        response = client.delete(
            "/cars/nonexistent-car",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 404

    def test_delete_car_with_error(self, client, mock_car_service):
        """DELETE /cars/{car_id} returns 400 on service error."""
        mock_car_service.delete_car.return_value = {"error": "Cannot delete default car"}

        response = client.delete(
            "/cars/car-123",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 400
        assert "Cannot delete" in response.json()["detail"]


class TestCarCredentials:
    """Tests for car credentials endpoints."""

    def test_save_credentials_success(self, client, mock_car_service):
        """PUT /cars/{car_id}/credentials saves credentials."""
        mock_car_service.save_car_credentials.return_value = {"status": "saved"}

        response = client.put(
            "/cars/car-123/credentials",
            json={
                "brand": "audi",
                "username": "user@email.com",
                "password": "secret123",
                "country": "NL",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_car_service.save_car_credentials.assert_called_once()

    def test_save_credentials_car_not_found(self, client, mock_car_service):
        """PUT /cars/{car_id}/credentials returns 404 for nonexistent car."""
        mock_car_service.save_car_credentials.return_value = None

        response = client.put(
            "/cars/nonexistent-car/credentials",
            json={
                "brand": "audi",
                "username": "user@email.com",
                "password": "secret",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 404

    def test_get_credentials_status(self, client, mock_car_service):
        """GET /cars/{car_id}/credentials returns credentials status."""
        mock_car_service.get_car_credentials_status.return_value = {
            "has_credentials": True,
            "brand": "audi",
            "username": "user@email.com",
            "last_updated": "2024-01-15T10:00:00Z",
        }

        response = client.get(
            "/cars/car-123/credentials",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["has_credentials"] is True
        assert "password" not in data

    def test_delete_credentials_success(self, client, mock_car_service):
        """DELETE /cars/{car_id}/credentials removes credentials."""
        mock_car_service.delete_car_credentials.return_value = {"status": "deleted"}

        response = client.delete(
            "/cars/car-123/credentials",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200


class TestTestCredentials:
    """Tests for POST /cars/{car_id}/credentials/test endpoint."""

    def test_test_credentials_audi_success(self, client, mock_car_service):
        """POST /cars/{car_id}/credentials/test validates Audi credentials."""
        mock_car_service.get_car.return_value = {"id": "car-123", "brand": "audi"}

        with patch("car_providers.AudiProvider") as mock_provider:
            mock_instance = MagicMock()
            mock_instance.get_data.return_value = MagicMock(
                vin="WAUXXXXXX12345678",
                odometer_km=50000,
                battery_level=80,
            )
            mock_provider.return_value = mock_instance

            response = client.post(
                "/cars/car-123/credentials/test",
                json={
                    "brand": "audi",
                    "username": "user@email.com",
                    "password": "secret",
                    "country": "NL",
                },
                headers={"X-User-Email": "test@example.com"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["status"] == "success"
            assert data["vin"] == "WAUXXXXXX12345678"
            mock_instance.disconnect.assert_called_once()

    def test_test_credentials_connection_failed(self, client, mock_car_service):
        """POST /cars/{car_id}/credentials/test returns error on connection failure."""
        mock_car_service.get_car.return_value = {"id": "car-123", "brand": "audi"}

        with patch("car_providers.AudiProvider") as mock_provider:
            mock_provider.return_value.get_data.side_effect = Exception("Auth failed")

            response = client.post(
                "/cars/car-123/credentials/test",
                json={
                    "brand": "audi",
                    "username": "user@email.com",
                    "password": "wrong-password",
                },
                headers={"X-User-Email": "test@example.com"},
            )

            assert response.status_code == 400
            assert "Connection failed" in response.json()["detail"]

    def test_test_credentials_unsupported_brand(self, client, mock_car_service):
        """POST /cars/{car_id}/credentials/test rejects unsupported brands."""
        mock_car_service.get_car.return_value = {"id": "car-123", "brand": "other"}

        response = client.post(
            "/cars/car-123/credentials/test",
            json={
                "brand": "unsupported_brand",
                "username": "user@email.com",
                "password": "secret",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 400
        assert "Unsupported brand" in response.json()["detail"]


class TestCarStats:
    """Tests for GET /cars/{car_id}/stats endpoint."""

    def test_get_car_stats_success(self, client, mock_car_service):
        """GET /cars/{car_id}/stats returns car statistics."""
        mock_car_service.get_car.return_value = {"id": "car-123", "name": "Audi A4"}

        # Create mock trips with explicit to_dict return values
        trip1_data = {"distance_km": 15.0, "business_km": 15.0, "private_km": 0}
        trip2_data = {"distance_km": 25.0, "business_km": 0, "private_km": 25.0}

        mock_trip1 = MagicMock()
        mock_trip1.to_dict.return_value = trip1_data
        mock_trip2 = MagicMock()
        mock_trip2.to_dict.return_value = trip2_data

        with patch("database.get_db") as mock_get_db:
            mock_query = MagicMock()
            mock_query.where.return_value.where.return_value.stream.return_value = iter([mock_trip1, mock_trip2])
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_query
            mock_get_db.return_value = mock_db

            response = client.get(
                "/cars/car-123/stats",
                headers={"X-User-Email": "test@example.com"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["trip_count"] == 2
            assert data["total_km"] == 40.0
            assert data["business_km"] == 15.0
            assert data["private_km"] == 25.0

    def test_get_car_stats_not_found(self, client, mock_car_service):
        """GET /cars/{car_id}/stats returns 404 for nonexistent car."""
        mock_car_service.get_car.return_value = None

        response = client.get(
            "/cars/nonexistent-car/stats",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 404
