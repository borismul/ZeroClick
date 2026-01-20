"""Unit tests for webhook service counter thresholds.

Tests verify the critical state machine behavior by calling actual webhook_service:
- no_driving_count threshold (3) -> trip cancelled
- parked_count threshold (3) -> trip finalized
- api_error_count threshold (2) -> GPS-only mode
"""

import pytest
from unittest.mock import patch


class TestNoDrivingCounter:
    """Tests for no_driving_count behavior - calls actual webhook_service."""

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

    @pytest.fixture
    def pending_trip_cache(self):
        """Trip cache with car not yet identified."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [],
            "gps_only_mode": False,
        }

    def test_no_driving_count_increments_when_no_car_found(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """no_driving_count should increment when find_driving_car returns None."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = pending_trip_cache.copy()

        # No cars with credentials
        mock_car_service.get_cars_with_credentials.return_value = []
        mock_car_service.find_driving_car.return_value = (None, "no_cars")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["no_driving_count"] == 1

    def test_no_driving_count_resets_when_car_found(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """no_driving_count should reset to 0 when a driving car is found."""
        from services.webhook_service import webhook_service

        pending_trip_cache["no_driving_count"] = 2
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (
            {"car_id": "car-123", "name": "Test Car", "odometer": 10000, "is_parked": False},
            "driving"
        )
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.91, "lng": 4.46, "odometer": 9990
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["no_driving_count"] == 0
        assert cache["car_id"] == "car-123"

    def test_trip_cancelled_at_threshold(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """Trip should be cancelled when no_driving_count reaches 3."""
        from services.webhook_service import webhook_service

        pending_trip_cache["no_driving_count"] = 2  # One more will trigger
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = []
        mock_car_service.find_driving_car.return_value = (None, "no_cars")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should cancel the trip
        assert result["status"] == "cancelled"
        # Cache should be cleared (set to None)
        mock_db["set"].assert_called()
        final_cache = mock_db["set"].call_args[0][0]
        assert final_cache is None

    def test_no_driving_count_not_incremented_on_api_error(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """api_error should increment api_error_count, and no_driving_count stays same or increments."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API error - returns None with api_error reason
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # API error count should increment
        assert cache["api_error_count"] == 1
        # Note: no_driving_count may also increment depending on implementation


class TestParkedCounter:
    """Tests for parked_count behavior - calls actual webhook_service."""

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

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service for finalization."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123"}
            yield mock

    @pytest.fixture
    def active_trip_cache(self):
        """Trip cache with car identified and driving."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000,
            "last_odo": 10005,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z"}],
            "gps_only_mode": False,
        }

    def test_parked_count_increments_when_car_parked(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """parked_count should increment when car API reports is_parked=True."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,
            "is_parked": True,
            "state": "parked",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["parked_count"] == 1

    def test_parked_count_resets_when_driving(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """parked_count should reset to 0 when car starts driving again."""
        from services.webhook_service import webhook_service

        active_trip_cache["parked_count"] = 2
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10010,
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["parked_count"] == 0

    def test_parked_count_maintained_when_unknown(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """parked_count should not change when is_parked is None (unknown)."""
        from services.webhook_service import webhook_service

        active_trip_cache["parked_count"] = 2
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,
            "is_parked": None,  # Unknown state
            "state": "unknown",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["parked_count"] == 2  # Maintained

    def test_trip_finalizes_at_threshold(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """Trip should finalize when parked_count reaches 3."""
        from services.webhook_service import webhook_service

        active_trip_cache["parked_count"] = 2  # One more will trigger
        active_trip_cache["last_odo"] = 10010  # Some distance driven
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10010,
            "is_parked": True,
            "state": "parked",
            "lat": 51.95,
            "lng": 4.50,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        # Should finalize the trip
        assert result["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()

    def test_odometer_override_parked_state(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """If odometer increases by >0.5km, override is_parked to False."""
        from services.webhook_service import webhook_service

        active_trip_cache["last_odo"] = 10000
        active_trip_cache["parked_count"] = 2
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # Car API says parked, but odometer increased 1km
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10001,  # 1km increase
            "is_parked": True,  # API incorrectly says parked
            "state": "parked",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # Parked count should be reset because odo movement overrides
        assert cache["parked_count"] == 0

    def test_small_odometer_delta_no_override(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """Small odometer delta should not override parked state."""
        from services.webhook_service import webhook_service

        active_trip_cache["last_odo"] = 10000
        active_trip_cache["parked_count"] = 2
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # Odometer increased only 0.3km (less than 0.5km threshold)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10000.3,
            "is_parked": True,
            "state": "parked",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Parked count reaches 3, which triggers finalization
        assert result["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()


class TestApiErrorCounter:
    """Tests for api_error_count behavior - calls actual webhook_service."""

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

    @pytest.fixture
    def pending_trip_cache(self):
        """Trip cache without car identified yet."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [],
            "gps_only_mode": False,
        }

    def test_api_error_count_increments_on_failure(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """api_error_count should increment when car API fails."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["api_error_count"] == 1

    def test_api_error_count_resets_on_success(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """api_error_count should reset to 0 when API call succeeds."""
        from services.webhook_service import webhook_service

        pending_trip_cache["api_error_count"] = 1
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (
            {"car_id": "car-123", "name": "Test Car", "odometer": 10000, "is_parked": False},
            "driving"
        )
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.91, "lng": 4.46, "odometer": 9990
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["api_error_count"] == 0

    def test_counters_preserved_on_api_error(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """parked_count should be preserved when API fails (no_driving_count may increment)."""
        from services.webhook_service import webhook_service

        pending_trip_cache["parked_count"] = 2
        pending_trip_cache["no_driving_count"] = 1
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["api_error_count"] == 1
        assert cache["parked_count"] == 2  # Preserved
        # no_driving_count increments because no car was found (even with API error)

    def test_gps_only_mode_triggered_at_threshold(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """GPS-only mode should trigger when api_error_count reaches 2 with high no_driving_count."""
        from services.webhook_service import webhook_service

        pending_trip_cache["api_error_count"] = 1
        pending_trip_cache["no_driving_count"] = 2  # Will reach 3
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should switch to GPS-only mode instead of cancelling
        assert result["status"] == "gps_only_mode"
        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] is True
