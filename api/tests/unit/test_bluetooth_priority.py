"""
Tests for Bluetooth car identification priority over API state.

Scenarios covered:
- Bluetooth identifies car but API says "parked" → Bluetooth wins
- Bluetooth car + API odometer data → combined correctly
"""

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime


class TestBluetoothPriority:
    """Test that Bluetooth identification takes priority over API parked state."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set:
            yield {"get": mock_get, "set": mock_set}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    def test_bluetooth_wins_over_api_parked_state(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """
        When Bluetooth identifies a car, trust it even if API says parked.
        The car was identified via Bluetooth = it's definitely driving.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        bluetooth_car_id = "audi-q5-bluetooth"

        # Initial state: no active trip
        mock_db["get"].return_value = None

        # Car service returns the Bluetooth car with API showing parked
        mock_car_service.get_car_id_by_device.return_value = None
        mock_car_service.get_default_car_id.return_value = None
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": bluetooth_car_id, "name": "Audi Q5", "brand": "audi"}
        ]
        # API says car is parked (wrong!), but has odometer
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": bluetooth_car_id,
            "name": "Audi Q5",
            "odometer": 50000,
            "is_parked": True,  # API incorrectly says parked
            "state": "parked",
            "lat": 51.92,
            "lng": 4.47,
        }
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.91,
            "lng": 4.46,
            "odometer": 49990,
        }

        # Ping with Bluetooth-identified car_id
        result = webhook_service.handle_ping(
            user_id=user_id,
            lat=51.92,
            lng=4.47,
            car_id=bluetooth_car_id,  # Bluetooth identified this car
        )

        # Should start trip despite API saying parked
        assert result["status"] == "trip_started"
        assert result["car"] == "Audi Q5"
        assert result["source"] == "bluetooth"

        # Verify trip cache was set with correct car
        set_call = mock_db["set"].call_args
        cache = set_call[0][0]
        assert cache["car_id"] == bluetooth_car_id
        assert cache["active"] == True

    def test_bluetooth_car_with_api_odometer_combined(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """
        When Bluetooth identifies car and API provides odometer,
        use Bluetooth for identity and API for odometer data.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        bluetooth_car_id = "tesla-model3"

        mock_db["get"].return_value = None

        mock_car_service.get_car_id_by_device.return_value = None
        mock_car_service.get_default_car_id.return_value = None
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": bluetooth_car_id, "name": "Tesla Model 3", "brand": "tesla"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": bluetooth_car_id,
            "name": "Tesla Model 3",
            "odometer": 25000,
            "is_parked": False,
            "state": "driving",
        }
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.90,
            "lng": 4.45,
            "odometer": 24990,
            "timestamp": "2024-01-19T09:00:00Z",
        }

        result = webhook_service.handle_ping(
            user_id=user_id,
            lat=51.92,
            lng=4.47,
            car_id=bluetooth_car_id,
        )

        assert result["status"] == "trip_started"
        assert result["source"] == "bluetooth"
        # Should use the parked odometer as start
        assert result["start_odo"] == 24990

        # Verify combined data in cache
        cache = mock_db["set"].call_args[0][0]
        assert cache["car_id"] == bluetooth_car_id
        assert cache["start_odo"] == 24990
        assert cache["gps_trail"][0]["lat"] == 51.90  # From last parked

    def test_bluetooth_car_no_api_credentials_gps_only(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """
        When Bluetooth identifies car but car has no API credentials,
        should fall back to GPS-only mode.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        bluetooth_car_id = "old-car-no-api"

        mock_db["get"].return_value = None

        mock_car_service.get_car_id_by_device.return_value = None
        mock_car_service.get_default_car_id.return_value = None
        # Car exists but no credentials
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id=user_id,
            lat=51.92,
            lng=4.47,
            car_id=bluetooth_car_id,
        )

        # Should enter GPS-only mode
        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] == True
        assert cache["car_id"] == bluetooth_car_id

    def test_bluetooth_car_api_unavailable_falls_back_after_errors(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """
        When Bluetooth identifies car but API keeps failing,
        should fall back to GPS-only mode after 2 errors.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        bluetooth_car_id = "audi-api-down"

        # First ping - API fails
        mock_db["get"].return_value = None
        mock_car_service.get_car_id_by_device.return_value = None
        mock_car_service.get_default_car_id.return_value = None
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": bluetooth_car_id, "name": "Audi A4", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = None  # API failed

        result1 = webhook_service.handle_ping(
            user_id=user_id, lat=51.92, lng=4.47, car_id=bluetooth_car_id
        )
        assert result1["status"] == "waiting_for_api"
        assert result1["api_error_count"] == 1

        # Second ping - API fails again
        cache_after_first = mock_db["set"].call_args[0][0]
        mock_db["get"].return_value = cache_after_first

        result2 = webhook_service.handle_ping(
            user_id=user_id, lat=51.93, lng=4.48, car_id=bluetooth_car_id
        )

        # Should switch to GPS-only mode
        assert result2["status"] == "gps_only_mode"
        assert result2["reason"] == "bluetooth_car_api_unavailable"

        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] == True
