"""Unit tests for car_service.py - car management and driving status.

Tests verify the car service logic by calling actual car_service:
- Default car management
- Car stats aggregation
- Credential status
- Driving status detection
- find_driving_car with error handling
"""

import pytest
from unittest.mock import patch, MagicMock


class TestDefaultCarManagement:
    """Tests for default car ID resolution."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        with patch("services.car_service.get_db") as mock:
            yield mock

    def test_get_default_car_returns_default(self, mock_db):
        """Returns car with is_default=True."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.id = "default-car-123"

        mock_cars_ref = MagicMock()
        mock_cars_ref.where.return_value.limit.return_value.stream.return_value = [mock_car_doc]

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_default_car_id("test@example.com")

        assert result == "default-car-123"

    def test_get_default_car_falls_back_to_first(self, mock_db):
        """Falls back to first car when no default set."""
        from services.car_service import car_service

        # No default car
        mock_first_car = MagicMock()
        mock_first_car.id = "first-car-456"

        mock_cars_ref = MagicMock()
        mock_cars_ref.where.return_value.limit.return_value.stream.return_value = []  # No default
        mock_cars_ref.limit.return_value.stream.return_value = [mock_first_car]

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_default_car_id("test@example.com")

        assert result == "first-car-456"

    def test_get_default_car_returns_none_when_no_cars(self, mock_db):
        """Returns None when user has no cars."""
        from services.car_service import car_service

        mock_cars_ref = MagicMock()
        mock_cars_ref.where.return_value.limit.return_value.stream.return_value = []
        mock_cars_ref.limit.return_value.stream.return_value = []

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_default_car_id("test@example.com")

        assert result is None


class TestCarIdByDevice:
    """Tests for device ID to car ID mapping."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        with patch("services.car_service.get_db") as mock:
            yield mock

    def test_finds_car_by_device_id(self, mock_db):
        """Returns car ID matching carplay_device_id."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.id = "carplay-car-789"

        mock_cars_ref = MagicMock()
        mock_cars_ref.where.return_value.limit.return_value.stream.return_value = [mock_car_doc]

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_car_id_by_device("test@example.com", "device-123")

        assert result == "carplay-car-789"

    def test_returns_none_for_unknown_device(self, mock_db):
        """Returns None when device ID not found."""
        from services.car_service import car_service

        mock_cars_ref = MagicMock()
        mock_cars_ref.where.return_value.limit.return_value.stream.return_value = []

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_car_id_by_device("test@example.com", "unknown-device")

        assert result is None

    def test_returns_none_for_empty_device_id(self, mock_db):
        """Returns None when device_id is empty."""
        from services.car_service import car_service

        result = car_service.get_car_id_by_device("test@example.com", "")

        assert result is None
        mock_db.return_value.collection.assert_not_called()


class TestCarsWithCredentials:
    """Tests for get_cars_with_credentials function."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        with patch("services.car_service.get_db") as mock:
            yield mock

    def test_returns_cars_with_password_auth(self, mock_db):
        """Returns cars that have username/password credentials."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.id = "audi-car"
        mock_car_doc.to_dict.return_value = {"name": "Audi A4", "brand": "audi"}

        mock_creds_doc = MagicMock()
        mock_creds_doc.exists = True
        mock_creds_doc.to_dict.return_value = {
            "username": "user@test.com",
            "password": "secret123",
            "brand": "audi",
        }

        mock_cars_ref = MagicMock()
        mock_cars_ref.stream.return_value = [mock_car_doc]
        mock_cars_ref.document.return_value.collection.return_value.document.return_value.get.return_value = mock_creds_doc

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_cars_with_credentials("test@example.com")

        assert len(result) == 1
        assert result[0]["car_id"] == "audi-car"
        assert result[0]["name"] == "Audi A4"
        assert "credentials" in result[0]

    def test_returns_cars_with_oauth_auth(self, mock_db):
        """Returns cars that have OAuth credentials."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.id = "oauth-car"
        mock_car_doc.to_dict.return_value = {"name": "Tesla Model 3", "brand": "tesla"}

        mock_creds_doc = MagicMock()
        mock_creds_doc.exists = True
        mock_creds_doc.to_dict.return_value = {
            "oauth_completed": True,
            "access_token": "token123",
            "brand": "audi",
        }

        mock_cars_ref = MagicMock()
        mock_cars_ref.stream.return_value = [mock_car_doc]
        mock_cars_ref.document.return_value.collection.return_value.document.return_value.get.return_value = mock_creds_doc

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_cars_with_credentials("test@example.com")

        assert len(result) == 1
        assert result[0]["car_id"] == "oauth-car"

    def test_excludes_cars_without_credentials(self, mock_db):
        """Excludes cars that have no credentials configured."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.id = "no-creds-car"
        mock_car_doc.to_dict.return_value = {"name": "Manual Car", "brand": "other"}

        mock_creds_doc = MagicMock()
        mock_creds_doc.exists = False

        mock_cars_ref = MagicMock()
        mock_cars_ref.stream.return_value = [mock_car_doc]
        mock_cars_ref.document.return_value.collection.return_value.document.return_value.get.return_value = mock_creds_doc

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value = mock_cars_ref

        result = car_service.get_cars_with_credentials("test@example.com")

        assert len(result) == 0


class TestCheckCarDrivingStatus:
    """Tests for check_car_driving_status function."""

    @pytest.fixture
    def mock_audi_provider(self):
        """Mock Audi provider - patch at the import location."""
        with patch("car_providers.AudiProvider") as mock:
            yield mock

    def test_returns_parked_when_car_parked(self, mock_audi_provider):
        """Returns is_parked=True when car API says parked."""
        from services.car_service import car_service
        from car_providers import VehicleState

        mock_data = MagicMock()
        mock_data.state = VehicleState.PARKED
        mock_data.odometer_km = 10500
        mock_data.latitude = 51.90
        mock_data.longitude = 4.45
        mock_data.raw_data = {}

        mock_audi_provider.return_value.get_data.return_value = mock_data
        mock_audi_provider.return_value.disconnect.return_value = None

        car_info = {
            "car_id": "audi-123",
            "name": "Audi A4",
            "brand": "audi",
            "credentials": {
                "oauth_completed": True,
                "access_token": "token123",
                "id_token": "id123",
            },
        }

        result = car_service.check_car_driving_status(car_info)

        assert result is not None
        assert result["is_parked"] is True
        assert result["state"] == "parked"
        assert result["odometer"] == 10500

    def test_returns_driving_when_car_moving(self, mock_audi_provider):
        """Returns is_parked=False when car API says driving."""
        from services.car_service import car_service
        from car_providers import VehicleState

        mock_data = MagicMock()
        mock_data.state = VehicleState.DRIVING
        mock_data.odometer_km = 10505
        mock_data.latitude = 51.92
        mock_data.longitude = 4.47
        mock_data.raw_data = {}

        mock_audi_provider.return_value.get_data.return_value = mock_data
        mock_audi_provider.return_value.disconnect.return_value = None

        car_info = {
            "car_id": "audi-123",
            "name": "Audi A4",
            "brand": "audi",
            "credentials": {
                "oauth_completed": True,
                "access_token": "token123",
            },
        }

        result = car_service.check_car_driving_status(car_info)

        assert result is not None
        assert result["is_parked"] is False
        assert result["is_driving"] is True
        assert result["state"] == "driving"

    def test_returns_none_on_api_error(self, mock_audi_provider):
        """Returns None when car API fails."""
        from services.car_service import car_service

        mock_audi_provider.return_value.get_data.side_effect = Exception("API Error")

        car_info = {
            "car_id": "audi-123",
            "name": "Audi A4",
            "brand": "audi",
            "credentials": {
                "oauth_completed": True,
                "access_token": "token123",
            },
        }

        result = car_service.check_car_driving_status(car_info)

        assert result is None

    def test_returns_gps_coordinates(self, mock_audi_provider):
        """Returns car GPS coordinates when available."""
        from services.car_service import car_service
        from car_providers import VehicleState

        mock_data = MagicMock()
        mock_data.state = VehicleState.PARKED
        mock_data.odometer_km = 10500
        mock_data.latitude = 51.95
        mock_data.longitude = 4.50
        mock_data.raw_data = {}

        mock_audi_provider.return_value.get_data.return_value = mock_data
        mock_audi_provider.return_value.disconnect.return_value = None

        car_info = {
            "car_id": "audi-123",
            "name": "Audi A4",
            "brand": "audi",
            "credentials": {
                "oauth_completed": True,
                "access_token": "token123",
            },
        }

        result = car_service.check_car_driving_status(car_info)

        assert result["lat"] == 51.95
        assert result["lng"] == 4.50


class TestFindDrivingCar:
    """Tests for find_driving_car function."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        with patch("services.car_service.get_db") as mock:
            yield mock

    @pytest.fixture
    def mock_check_status(self):
        """Mock check_car_driving_status."""
        with patch.object(
            __import__("services.car_service", fromlist=["car_service"]).car_service,
            "check_car_driving_status"
        ) as mock:
            yield mock

    @pytest.fixture
    def mock_get_cars_with_credentials(self):
        """Mock get_cars_with_credentials."""
        with patch.object(
            __import__("services.car_service", fromlist=["car_service"]).car_service,
            "get_cars_with_credentials"
        ) as mock:
            yield mock

    def test_finds_driving_car_among_multiple(self, mock_get_cars_with_credentials, mock_check_status, mock_db):
        """Returns the car that is currently driving."""
        from services.car_service import car_service

        mock_get_cars_with_credentials.return_value = [
            {"car_id": "car-1", "name": "Car 1", "brand": "audi", "credentials": {}},
            {"car_id": "car-2", "name": "Car 2", "brand": "audi", "credentials": {}},
            {"car_id": "car-3", "name": "Car 3", "brand": "audi", "credentials": {}},
        ]

        def check_status_side_effect(car_info):
            if car_info["car_id"] == "car-2":
                return {
                    "car_id": "car-2",
                    "name": "Car 2",
                    "is_parked": False,
                    "is_driving": True,
                    "odometer": 10000,
                }
            return {
                "car_id": car_info["car_id"],
                "name": car_info["name"],
                "is_parked": True,
                "is_driving": False,
                "lat": 51.90,
                "lng": 4.45,
            }

        mock_check_status.side_effect = check_status_side_effect

        # Mock get_last_parked_gps
        with patch.object(car_service, "get_last_parked_gps", return_value=None):
            with patch.object(car_service, "save_last_parked_gps"):
                result, reason = car_service.find_driving_car("test@example.com")

        assert result is not None
        assert result["car_id"] == "car-2"
        assert reason == "driving"

    def test_returns_parked_when_all_parked(self, mock_get_cars_with_credentials, mock_check_status, mock_db):
        """Returns (None, 'parked') when all cars are parked."""
        from services.car_service import car_service

        mock_get_cars_with_credentials.return_value = [
            {"car_id": "car-1", "name": "Car 1", "brand": "audi", "credentials": {}},
            {"car_id": "car-2", "name": "Car 2", "brand": "audi", "credentials": {}},
        ]

        mock_check_status.return_value = {
            "is_parked": True,
            "is_driving": False,
            "lat": 51.90,
            "lng": 4.45,
        }

        with patch.object(car_service, "save_last_parked_gps"):
            result, reason = car_service.find_driving_car("test@example.com")

        assert result is None
        assert reason == "parked"

    def test_returns_no_cars_when_none_configured(self, mock_get_cars_with_credentials, mock_db):
        """Returns (None, 'no_cars') when no cars with credentials."""
        from services.car_service import car_service

        mock_get_cars_with_credentials.return_value = []

        result, reason = car_service.find_driving_car("test@example.com")

        assert result is None
        assert reason == "no_cars"

    def test_returns_api_error_when_all_fail(self, mock_get_cars_with_credentials, mock_check_status, mock_db):
        """Returns (None, 'api_error') when all API checks fail."""
        from services.car_service import car_service

        mock_get_cars_with_credentials.return_value = [
            {"car_id": "car-1", "name": "Car 1", "brand": "audi", "credentials": {}},
            {"car_id": "car-2", "name": "Car 2", "brand": "audi", "credentials": {}},
        ]

        mock_check_status.return_value = None  # All API calls fail

        result, reason = car_service.find_driving_car("test@example.com")

        assert result is None
        assert reason == "api_error"


class TestLastParkedGPS:
    """Tests for last parked GPS save/retrieve."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        with patch("services.car_service.get_db") as mock:
            yield mock

    def test_saves_last_parked_gps(self, mock_db):
        """Saves last parked GPS position."""
        from services.car_service import car_service

        mock_car_ref = MagicMock()
        mock_db.return_value.collection.return_value.document.return_value.collection.return_value.document.return_value = mock_car_ref

        car_service.save_last_parked_gps(
            user_id="test@example.com",
            car_id="car-123",
            lat=51.95,
            lng=4.50,
            timestamp="2024-01-15T17:00:00Z",
            odometer=10500,
        )

        mock_car_ref.update.assert_called_once()
        call_args = mock_car_ref.update.call_args[0][0]
        assert call_args["last_parked_lat"] == 51.95
        assert call_args["last_parked_lng"] == 4.50
        assert call_args["last_parked_odo"] == 10500

    def test_retrieves_last_parked_gps(self, mock_db):
        """Retrieves saved last parked GPS."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.exists = True
        mock_car_doc.to_dict.return_value = {
            "last_parked_lat": 51.95,
            "last_parked_lng": 4.50,
            "last_parked_at": "2024-01-15T17:00:00Z",
            "last_parked_odo": 10500,
        }

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value.document.return_value.get.return_value = mock_car_doc

        result = car_service.get_last_parked_gps("test@example.com", "car-123")

        assert result is not None
        assert result["lat"] == 51.95
        assert result["lng"] == 4.50
        assert result["odometer"] == 10500

    def test_returns_none_when_no_parked_data(self, mock_db):
        """Returns None when no parked GPS saved."""
        from services.car_service import car_service

        mock_car_doc = MagicMock()
        mock_car_doc.exists = True
        mock_car_doc.to_dict.return_value = {
            "name": "Test Car",
            # No last_parked fields
        }

        mock_db.return_value.collection.return_value.document.return_value.collection.return_value.document.return_value.get.return_value = mock_car_doc

        result = car_service.get_last_parked_gps("test@example.com", "car-123")

        assert result is None
