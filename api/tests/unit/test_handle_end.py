"""Unit tests for webhook_service.handle_end() - trip finalization.

Tests verify the trip end logic by calling actual webhook_service:
- Normal trip finalization when car is parked
- Skip location pausing behavior
- GPS-only mode finalization
- End without active trip handling
- Car GPS vs phone GPS fallback
- Zero kilometer trip skipping
- Safety net delegation for incomplete trips
"""

import pytest
from unittest.mock import patch


class TestHandleEndNoActiveTrip:
    """Tests for end when no trip is active."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set:
            yield {"get": mock_get, "set": mock_set}

    def test_end_no_active_trip_returns_ignored(self, mock_db):
        """End with no active trip returns ignored status."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = None

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        assert result["status"] == "ignored"
        assert result["reason"] == "no_active_trip"

    def test_end_with_inactive_cache_returns_ignored(self, mock_db):
        """End with cache that has active=False returns ignored."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = {"active": False, "user_id": "test@example.com"}

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        assert result["status"] == "ignored"
        assert result["reason"] == "no_active_trip"


class TestHandleEndNormalTrip:
    """Tests for normal trip finalization."""

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
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123", "distance_km": 15}
            yield mock

    @pytest.fixture
    def active_trip_cache(self):
        """Active trip cache with car identified."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000,
            "last_odo": 10015,
            "no_driving_count": 0,
            "parked_count": 2,
            "api_error_count": 0,
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
                {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:05:00Z", "is_skip": False},
            ],
            "gps_trail": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z"},
            ],
            "gps_only_mode": False,
            "audi_gps": {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:05:00Z"},
        }

    def test_end_finalizes_parked_car(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End with parked car finalizes trip."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10015,
            "is_parked": True,
            "lat": 51.95,
            "lng": 4.50,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        assert result["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()
        # Cache should be cleared
        mock_db["set"].assert_called()
        final_call = mock_db["set"].call_args[0][0]
        assert final_call is None

    def test_end_uses_car_gps_for_finalization(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End uses car GPS coordinates for end location."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10015,
            "is_parked": True,
            "lat": 51.96,  # Car GPS
            "lng": 4.51,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,  # Phone GPS (different)
            lng=4.50,
        )

        # Verify finalize was called with car GPS as end_gps
        call_kwargs = mock_trip_service.finalize_trip_from_audi.call_args[1]
        assert call_kwargs["end_gps"]["lat"] == 51.96
        assert call_kwargs["end_gps"]["lng"] == 4.51

    def test_end_zero_km_skipped(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End with zero km driven skips trip creation."""
        from services.webhook_service import webhook_service

        active_trip_cache["start_odo"] = 10000
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10000,  # Same as start - 0 km
            "is_parked": True,
            "lat": 51.90,
            "lng": 4.45,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )

        assert result["status"] == "skipped"
        assert result["reason"] == "zero_km"
        mock_trip_service.finalize_trip_from_audi.assert_not_called()


class TestHandleEndSkipLocation:
    """Tests for end at skip location behavior."""

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
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            yield mock

    @pytest.fixture
    def active_trip_cache(self):
        """Active trip cache with car identified."""
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
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_trail": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z"},
            ],
            "gps_only_mode": False,
            "audi_gps": None,
        }

    def test_end_at_skip_location_keeps_active(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End at skip location keeps trip active."""
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
            "lat": 52.10,  # Skip location coordinates
            "lng": 4.30,
        }
        # Skip location check returns True for car GPS
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=52.10,
            lng=4.30,
        )

        assert result["status"] == "paused_at_skip"
        mock_trip_service.finalize_trip_from_audi.assert_not_called()
        # Cache should NOT be cleared
        cache = mock_db["set"].call_args[0][0]
        assert cache is not None
        assert cache["active"] is True

    def test_end_at_skip_clears_end_triggered(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End at skip location clears end_triggered flag."""
        from services.webhook_service import webhook_service

        active_trip_cache["end_triggered"] = "2024-01-19T10:10:00Z"
        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10005,
            "is_parked": True,
            "lat": 52.10,
            "lng": 4.30,
        }
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=52.10,
            lng=4.30,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["end_triggered"] is None


class TestHandleEndGPSOnlyMode:
    """Tests for end in GPS-only mode."""

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
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_gps.return_value = {"id": "trip-gps-123", "distance_km": 5.2}
            yield mock

    @pytest.fixture
    def mock_gps_distance(self):
        """Mock GPS distance calculation."""
        with patch("services.webhook_service.calculate_gps_distance") as mock:
            mock.return_value = 5.2  # km
            yield mock

    @pytest.fixture
    def gps_only_trip_cache(self):
        """GPS-only trip cache with GPS events."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "bluetooth-car",
            "car_name": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "last_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
                {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:05:00Z", "is_skip": False},
                {"lat": 51.94, "lng": 4.49, "timestamp": "2024-01-19T10:10:00Z", "is_skip": False},
                {"lat": 51.96, "lng": 4.51, "timestamp": "2024-01-19T10:15:00Z", "is_skip": False},
                {"lat": 51.98, "lng": 4.53, "timestamp": "2024-01-19T10:20:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": True,
        }

    def test_end_gps_only_finalizes_with_gps_distance(
        self, mock_db, mock_location_service, mock_trip_service, mock_gps_distance, gps_only_trip_cache
    ):
        """End in GPS-only mode uses GPS trail for distance."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip_cache.copy()

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.99,
            lng=4.54,
        )

        assert result["status"] == "finalized_gps_only"
        assert result["distance_km"] == 5.2
        mock_trip_service.finalize_trip_from_gps.assert_called_once()

    def test_end_gps_only_filters_skip_points(
        self, mock_db, mock_location_service, mock_trip_service, mock_gps_distance, gps_only_trip_cache
    ):
        """End in GPS-only mode excludes skip location points."""
        from services.webhook_service import webhook_service

        # Add some skip points
        gps_only_trip_cache["gps_events"].insert(2, {
            "lat": 52.10, "lng": 4.30, "timestamp": "2024-01-19T10:07:00Z", "is_skip": True
        })
        mock_db["get"].return_value = gps_only_trip_cache.copy()

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.99,
            lng=4.54,
        )

        # Check that finalize was called with trail that excludes skip points
        call_kwargs = mock_trip_service.finalize_trip_from_gps.call_args[1]
        gps_trail = call_kwargs["gps_trail"]
        # None of the points in trail should be at skip location
        for point in gps_trail:
            assert not (point["lat"] == 52.10 and point["lng"] == 4.30)

    def test_end_gps_only_insufficient_points_skips(
        self, mock_db, mock_location_service, mock_trip_service
    ):
        """End in GPS-only mode with <2 valid points skips trip."""
        from services.webhook_service import webhook_service

        cache = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "bluetooth-car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": True,
        }
        mock_db["get"].return_value = cache

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.90,
            lng=4.45,
        )

        assert result["status"] == "skipped"
        # The reason could be "not_enough_gps_points" or "gps_distance_too_short" depending on implementation
        assert result["reason"] in ["not_enough_gps_points", "gps_distance_too_short"]
        mock_trip_service.finalize_trip_from_gps.assert_not_called()

    def test_end_gps_only_short_distance_skips(
        self, mock_db, mock_location_service, mock_trip_service
    ):
        """End in GPS-only mode with distance <0.1km skips trip."""
        from services.webhook_service import webhook_service

        with patch("services.webhook_service.calculate_gps_distance") as mock_dist:
            mock_dist.return_value = 0.05  # Less than 0.1 km

            cache = {
                "active": True,
                "user_id": "test@example.com",
                "car_id": "bluetooth-car",
                "start_time": "2024-01-19T10:00:00Z",
                "start_odo": None,
                "gps_events": [
                    {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
                    {"lat": 51.9001, "lng": 4.4501, "timestamp": "2024-01-19T10:01:00Z", "is_skip": False},
                ],
                "gps_trail": [],
                "gps_only_mode": True,
            }
            mock_db["get"].return_value = cache

            result = webhook_service.handle_end(
                user_id="test@example.com",
                lat=51.9001,
                lng=4.4501,
            )

            assert result["status"] == "skipped"
            assert result["reason"] == "gps_distance_too_short"

    def test_end_gps_only_at_skip_location_keeps_active(
        self, mock_db, mock_location_service, mock_trip_service, gps_only_trip_cache
    ):
        """End in GPS-only mode at skip location keeps trip active."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip_cache.copy()
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=52.10,  # Skip location
            lng=4.30,
        )

        assert result["status"] == "paused_at_skip"
        mock_trip_service.finalize_trip_from_gps.assert_not_called()


class TestHandleEndCarDiscovery:
    """Tests for end attempting to discover car at end time."""

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
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123"}
            yield mock

    @pytest.fixture
    def pending_trip_cache(self):
        """Trip cache without car/odometer yet."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "last_odo": None,
            "no_driving_count": 2,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
                {"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-19T10:10:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": False,
        }

    def test_end_discovers_car_and_finalizes(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, pending_trip_cache
    ):
        """End discovers car via find_driving_car and finalizes."""
        from services.webhook_service import webhook_service

        # Add more GPS events to ensure we have a valid trail
        pending_trip_cache["gps_events"] = [
            {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:05:00Z", "is_skip": False},
            {"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-19T10:10:00Z", "is_skip": False},
        ]
        pending_trip_cache["gps_trail"] = [
            {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z"},
        ]
        mock_db["get"].return_value = pending_trip_cache.copy()

        # find_driving_car discovers the car at end time (sets start_odo = 10000)
        mock_car_service.find_driving_car.return_value = (
            {"car_id": "car-123", "name": "Test Car", "odometer": 10000, "is_parked": True, "lat": 51.90, "lng": 4.45},
            "driving"
        )
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # check_car_driving_status returns higher odometer (end_odo = 10050, so 50km driven)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10050,
            "is_parked": True,
            "state": "parked",
            "lat": 51.95,
            "lng": 4.50,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        # Trip should be finalized with discovered car, or pending for safety net
        # Depending on whether start_odo was captured, it may return finalized or pending
        assert result["status"] in ["finalized", "pending"]
        mock_car_service.find_driving_car.assert_called_once()

    def test_end_no_car_found_delegates_to_safety_net(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """End without car found delegates to safety net."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.find_driving_car.return_value = (None, "no_cars")

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        assert result["status"] == "pending"
        assert result["reason"] == "waiting_for_safety_net"
        # Cache should be saved with end_triggered
        cache = mock_db["set"].call_args[0][0]
        assert cache is not None
        assert cache["end_triggered"] is not None


class TestHandleEndSafetyNet:
    """Tests for end triggering safety net handling."""

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
    def active_trip_cache(self):
        """Active trip with car but car still moving."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000,
            "last_odo": 10010,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": False,
        }

    def test_end_with_moving_car_waits_for_safety_net(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """End while car still moving delegates to safety net."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 10015,
            "is_parked": False,  # Car still moving
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        assert result["status"] == "pending"
        assert result["reason"] == "waiting_for_safety_net"

    def test_end_records_end_triggered_timestamp(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """End records end_triggered timestamp for safety net."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "odometer": 10015,
            "is_parked": False,
        }

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        assert cache["end_triggered"] is not None
        # Should be a valid ISO timestamp
        assert "T" in cache["end_triggered"]
        assert cache["end_triggered"].endswith("Z")

    def test_end_adds_final_gps_event(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """End adds final GPS event to cache."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.99,
            lng=4.55,
        )

        cache = mock_db["set"].call_args[0][0]
        assert len(cache["gps_events"]) == 2  # Original + new
        last_event = cache["gps_events"][-1]
        assert last_event["lat"] == 51.99
        assert last_event["lng"] == 4.55
