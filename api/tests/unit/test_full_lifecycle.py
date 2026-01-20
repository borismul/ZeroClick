"""Integration tests for complete trip lifecycle scenarios.

These tests verify that the webhook_service state machine works correctly
across multiple pings, from trip start to finalization. They test the
interaction between handle_start, handle_ping, and handle_end.

Each test simulates a realistic trip scenario with multiple state transitions.
"""

import pytest
from unittest.mock import patch, MagicMock


class TestNormalTripLifecycle:
    """Tests for normal trip from home to destination."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions with stateful storage."""
        storage = {"cache": None}

        def get_cache(user_id):
            return storage["cache"].copy() if storage["cache"] else None

        def set_cache(cache, user_id):
            storage["cache"] = cache.copy() if cache else None

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache) as mock_get, \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache) as mock_set:
            yield {"get": mock_get, "set": mock_set, "storage": storage}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_car_id_by_device.return_value = None
            mock.get_default_car_id.return_value = "car-123"
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {
                "id": "trip-lifecycle-001",
                "distance_km": 15.5,
                "classification": "B",
            }
            yield mock

    def test_normal_trip_home_to_office(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service
    ):
        """Complete trip from home to office with car API."""
        from services.webhook_service import webhook_service

        # Configure mock responses for the lifecycle BEFORE calling handle_start
        mock_car_service.find_driving_car.return_value = (
            {"car_id": "car-123", "name": "Test Car", "odometer": 10000, "is_parked": False},
            "driving"
        )
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.90, "lng": 4.45, "odometer": 9999, "timestamp": "2024-01-19T09:55:00Z"
        }
        # Set up check_car_driving_status before handle_start since it's called during start
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10000,
            "is_parked": False,
            "state": "driving",
            "lat": 51.90,
            "lng": 4.45,
        }

        # Step 1: Trip start (motion detected)
        result1 = webhook_service.handle_start(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )
        assert mock_db["storage"]["cache"]["active"] is True
        assert mock_db["storage"]["cache"]["car_id"] == "car-123"
        assert mock_db["storage"]["cache"]["start_odo"] == 9999  # From last_parked

        # Step 2: First ping - car still driving
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,
            "is_parked": False,
            "state": "driving",
            "lat": 51.91,
            "lng": 4.46,
        }

        result2 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.91,
            lng=4.46,
        )
        assert mock_db["storage"]["cache"]["parked_count"] == 0

        # Step 3: Middle of trip - still driving
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10010,
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result3 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )
        assert mock_db["storage"]["cache"]["parked_count"] == 0
        assert mock_db["storage"]["cache"]["last_odo"] == 10010

        # Step 4: Arrived at office - parked (count 1)
        # Note: odometer stays same when parked (if it increases >0.5km, is_parked gets overridden)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10010,  # Same as last, car is parked
            "is_parked": True,
            "state": "parked",
            "lat": 51.95,
            "lng": 4.50,
        }

        result4 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )
        assert mock_db["storage"]["cache"]["parked_count"] == 1

        # Step 5: Still parked (count 2)
        result5 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )
        assert mock_db["storage"]["cache"]["parked_count"] == 2

        # Step 6: Still parked (count 3) -> Trip finalized
        result6 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        assert result6["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()

        # Verify finalization call arguments
        call_kwargs = mock_trip_service.finalize_trip_from_audi.call_args[1]
        assert call_kwargs["start_odo"] == 9999
        assert call_kwargs["end_odo"] == 10010  # Final odometer when parked
        assert call_kwargs["user_id"] == "test@example.com"
        assert call_kwargs["car_id"] == "car-123"

        # Cache should be cleared
        assert mock_db["storage"]["cache"] is None


class TestTripWithSkipLocationStop:
    """Tests for trip with stop at skip location (e.g., daycare)."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions with stateful storage."""
        storage = {"cache": None}

        def get_cache(user_id):
            return storage["cache"].copy() if storage["cache"] else None

        def set_cache(cache, user_id):
            storage["cache"] = cache.copy() if cache else None

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache) as mock_get, \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache) as mock_set:
            yield {"get": mock_get, "set": mock_set, "storage": storage}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_car_id_by_device.return_value = None
            mock.get_default_car_id.return_value = "car-123"
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service with skip location."""
        with patch("services.webhook_service.location_service") as mock:
            # Will configure per-call
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {
                "id": "trip-skip-001",
                "distance_km": 25.0,
            }
            yield mock

    def test_trip_with_skip_location_stop_continues(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service
    ):
        """Trip stops at skip location but continues afterward."""
        from services.webhook_service import webhook_service

        # Set up all mocks BEFORE calling handle_start
        mock_location_service.is_skip_location.return_value = False
        mock_car_service.find_driving_car.return_value = (
            {"car_id": "car-123", "name": "Test Car", "odometer": 10000, "is_parked": False},
            "driving"
        )
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.90, "lng": 4.45, "odometer": 10000
        }
        # Set up check_car_driving_status before handle_start
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10000,
            "is_parked": False,
            "state": "driving",
            "lat": 51.90,
            "lng": 4.45,
        }

        # Step 1: Start trip
        webhook_service.handle_start(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )

        # Step 2: Driving to skip location
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,
            "is_parked": False,
            "state": "driving",
            "lat": 51.92,
            "lng": 4.47,
        }
        webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.92,
            lng=4.47,
        )

        # Step 3: Arrive at skip location - parked
        # Note: odometer stays same or only slight increase when parked (>0.5km increase overrides is_parked)
        mock_location_service.is_skip_location.return_value = True  # Now at skip
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,  # Same as last - car is parked
            "is_parked": True,  # Parked
            "state": "parked",
            "lat": 52.10,
            "lng": 4.30,
        }

        result3 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=52.10,
            lng=4.30,
        )
        # First parked ping at skip - parked_count increments (not yet paused)
        assert mock_db["storage"]["cache"]["active"] is True
        assert mock_db["storage"]["cache"]["parked_count"] == 1

        # Step 4-6: Multiple pings at skip - eventually triggers paused_at_skip after 3 parked pings
        for i in range(2):
            result = webhook_service.handle_ping(
                user_id="test@example.com",
                lat=52.10,
                lng=4.30,
            )

        # After 3 parked pings at skip location, should be paused_at_skip
        result_skip = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=52.10,
            lng=4.30,
        )
        assert result_skip["status"] == "paused_at_skip"

        # Trip should still be active (not finalized at skip location)
        assert mock_db["storage"]["cache"]["active"] is True

        # Step 7: Leave skip location, continue driving
        mock_location_service.is_skip_location.return_value = False
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10015,
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result7 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )
        assert result7["status"] in ["moving", "waiting"]

        # Step 8-10: Arrive at final destination, parked 3x -> finalized
        # Note: odometer stays same when parked (>0.5km increase overrides is_parked)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10015,  # Same as driving - car has stopped
            "is_parked": True,
            "state": "parked",
            "lat": 51.95,
            "lng": 4.50,
        }

        for i in range(3):
            result = webhook_service.handle_ping(
                user_id="test@example.com",
                lat=51.95,
                lng=4.50,
            )

        assert result["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()

        # Distance should be total (10015 - 10000 = 15 km)
        call_kwargs = mock_trip_service.finalize_trip_from_audi.call_args[1]
        assert call_kwargs["start_odo"] == 10000
        assert call_kwargs["end_odo"] == 10015


class TestTripWithAPIErrorFallback:
    """Tests for trip where car API fails and switches to GPS-only mode."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions with stateful storage."""
        storage = {"cache": None}

        def get_cache(user_id):
            return storage["cache"].copy() if storage["cache"] else None

        def set_cache(cache, user_id):
            storage["cache"] = cache.copy() if cache else None

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache) as mock_get, \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache) as mock_set:
            yield {"get": mock_get, "set": mock_set, "storage": storage}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_car_id_by_device.return_value = None
            mock.get_default_car_id.return_value = "car-123"
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_gps.return_value = {
                "id": "trip-gps-001",
                "distance_km": 12.5,
            }
            yield mock

    @pytest.fixture
    def mock_gps_distance(self):
        """Mock GPS distance calculation."""
        with patch("services.webhook_service.calculate_gps_distance") as mock:
            mock.return_value = 12.5
            yield mock

    def test_trip_with_api_errors_falls_back_to_gps(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, mock_gps_distance
    ):
        """Trip falls back to GPS-only mode after API errors."""
        from services.webhook_service import webhook_service

        # For this test, don't assign a car from Bluetooth/default so find_driving_car is used
        mock_car_service.get_default_car_id.return_value = None
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        # Step 1: Start trip
        webhook_service.handle_start(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )
        # First ping happens during handle_start, api_error_count gets set
        assert mock_db["storage"]["cache"]["api_error_count"] == 1

        # Step 2: Second call - API error (counts increment)
        result2 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.91,
            lng=4.46,
        )
        assert mock_db["storage"]["cache"]["api_error_count"] == 2
        assert mock_db["storage"]["cache"]["no_driving_count"] == 2

        # Step 3: Third ping - triggers GPS-only mode (3+ errors)
        result3 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.92,
            lng=4.47,
        )
        assert result3["status"] == "gps_only_mode"
        assert mock_db["storage"]["cache"]["gps_only_mode"] is True

        # Step 5-8: Continue collecting GPS points in GPS-only mode
        for i, coords in enumerate([
            (51.94, 4.49),
            (51.95, 4.50),
            (51.96, 4.51),
            (51.97, 4.52),
        ]):
            result = webhook_service.handle_ping(
                user_id="test@example.com",
                lat=coords[0],
                lng=coords[1],
            )
            assert result["status"] == "gps_only_ping"

        # Step 9: End trip - should finalize with GPS distance
        result_end = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.98,
            lng=4.53,
        )

        assert result_end["status"] == "finalized_gps_only"
        mock_trip_service.finalize_trip_from_gps.assert_called_once()

        # Verify GPS trail was passed
        call_kwargs = mock_trip_service.finalize_trip_from_gps.call_args[1]
        assert len(call_kwargs["gps_trail"]) >= 2  # At least start and end


class TestTripCancelledNoCarFound:
    """Tests for trip cancelled when no driving car is found."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions with stateful storage."""
        storage = {"cache": None}

        def get_cache(user_id):
            return storage["cache"].copy() if storage["cache"] else None

        def set_cache(cache, user_id):
            storage["cache"] = cache.copy() if cache else None

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache) as mock_get, \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache) as mock_set:
            yield {"get": mock_get, "set": mock_set, "storage": storage}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_car_id_by_device.return_value = None
            mock.get_default_car_id.return_value = None  # No default car
            mock.get_cars_with_credentials.return_value = []  # No cars with creds
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    def test_trip_cancelled_after_3_pings_no_car(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """Trip cancelled after 3 pings with no driving car found."""
        from services.webhook_service import webhook_service

        # All find_driving_car calls return no car (not API error, just no cars)
        mock_car_service.find_driving_car.return_value = (None, "all_parked")

        # Start trip and send multiple pings until cancelled
        result1 = webhook_service.handle_start(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )
        # After handle_start with no car: active trip, waiting_for_car
        assert result1.get("status") == "waiting_for_car"

        # Continue pinging until trip is cancelled (max 5 attempts)
        cancelled = False
        for i, coords in enumerate([(51.91, 4.46), (51.92, 4.47), (51.93, 4.48), (51.94, 4.49), (51.95, 4.50)]):
            result = webhook_service.handle_ping(
                user_id="test@example.com",
                lat=coords[0],
                lng=coords[1],
            )
            if result.get("status") == "cancelled":
                cancelled = True
                break

        # Trip should be cancelled after 3 pings with no driving car found
        assert cancelled, f"Expected trip to be cancelled, got: {result}"
        assert mock_db["storage"]["cache"] is None  # Cache cleared


class TestTripWithBluetoothCarIdentification:
    """Tests for trip where Bluetooth identifies car immediately."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions with stateful storage."""
        storage = {"cache": None}

        def get_cache(user_id):
            return storage["cache"].copy() if storage["cache"] else None

        def set_cache(cache, user_id):
            storage["cache"] = cache.copy() if cache else None

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache) as mock_get, \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache) as mock_set:
            yield {"get": mock_get, "set": mock_set, "storage": storage}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_car_id_by_device.return_value = None
            mock.get_default_car_id.return_value = None
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "bluetooth-car", "name": "Bluetooth Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-bt-001"}
            yield mock

    def test_trip_with_bluetooth_car_id_skips_find_driving_car(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service
    ):
        """Trip started with Bluetooth car_id doesn't call find_driving_car."""
        from services.webhook_service import webhook_service

        # Bluetooth provides car_id directly
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "bluetooth-car",
            "name": "Bluetooth Car",
            "odometer": 20000,
            "is_parked": False,
            "state": "driving",
            "lat": 51.91,
            "lng": 4.46,
        }
        mock_car_service.get_last_parked_gps.return_value = {
            "lat": 51.90, "lng": 4.45, "odometer": 19995
        }

        # Start with explicit car_id from Bluetooth
        result1 = webhook_service.handle_start(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
            car_id="bluetooth-car",
        )

        # Car should be assigned immediately
        assert mock_db["storage"]["cache"]["car_id"] == "bluetooth-car"

        # First ping should use check_car_driving_status, not find_driving_car
        result2 = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.91,
            lng=4.46,
        )

        # Should have odometer from last_parked
        assert mock_db["storage"]["cache"]["start_odo"] == 19995

        # find_driving_car should NOT have been called
        mock_car_service.find_driving_car.assert_not_called()

        # Complete the trip - odometer stays same when parked
        # (>0.5km increase would override is_parked to False)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "bluetooth-car",
            "name": "Bluetooth Car",
            "odometer": 20000,  # Same as last - car is parked
            "is_parked": True,
            "state": "parked",
            "lat": 51.95,
            "lng": 4.50,
        }

        for _ in range(3):
            webhook_service.handle_ping(
                user_id="test@example.com",
                lat=51.95,
                lng=4.50,
            )

        mock_trip_service.finalize_trip_from_audi.assert_called_once()
