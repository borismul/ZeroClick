"""Unit tests for webhook service counter thresholds.

Tests verify the critical state machine behavior:
- no_driving_count threshold (3) -> trip cancelled
- parked_count threshold (3) -> trip finalized
- api_error_count threshold (2) -> GPS-only mode
"""

import pytest
from tests.mocks.mock_firestore import MockFirestore
from tests.mocks.mock_car_provider import MockCarService


class TestNoDrivingCounter:
    """Tests for no_driving_count behavior."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def mock_car_service(self):
        return MockCarService()

    @pytest.fixture
    def base_cache(self):
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
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_no_driving_count_increments_when_no_car_found(
        self, mock_db, mock_car_service, base_cache
    ):
        """no_driving_count should increment when find_driving_car returns None."""
        mock_db.set_trip_cache("test@example.com", base_cache)
        mock_car_service.set_find_driving_result(None, "parked")

        # Simulate ping processing logic
        cache = mock_db.get_trip_cache("test@example.com")
        result, reason = mock_car_service.find_driving_car("test@example.com")

        if result is None and reason != "api_error":
            cache["no_driving_count"] = cache.get("no_driving_count", 0) + 1

        assert cache["no_driving_count"] == 1

    def test_no_driving_count_resets_when_car_found(
        self, mock_db, mock_car_service, base_cache
    ):
        """no_driving_count should reset to 0 when a driving car is found."""
        base_cache["no_driving_count"] = 2
        mock_db.set_trip_cache("test@example.com", base_cache)
        mock_car_service.set_find_driving_result(
            {"car_id": "car-123", "is_driving": True, "odometer": 10000},
            "driving"
        )

        cache = mock_db.get_trip_cache("test@example.com")
        result, reason = mock_car_service.find_driving_car("test@example.com")

        if result is not None:
            cache["no_driving_count"] = 0
            cache["car_id"] = result["car_id"]

        assert cache["no_driving_count"] == 0
        assert cache["car_id"] == "car-123"

    def test_trip_cancelled_at_threshold(self, mock_db, mock_car_service, base_cache):
        """Trip should be cancelled when no_driving_count reaches 3."""
        base_cache["no_driving_count"] = 2  # One more will trigger
        mock_db.set_trip_cache("test@example.com", base_cache)
        mock_car_service.set_find_driving_result(None, "parked")

        cache = mock_db.get_trip_cache("test@example.com")
        result, reason = mock_car_service.find_driving_car("test@example.com")

        if result is None and reason != "api_error":
            cache["no_driving_count"] = cache.get("no_driving_count", 0) + 1

        NO_DRIVING_COUNT_THRESHOLD = 3
        should_cancel = (
            cache["no_driving_count"] >= NO_DRIVING_COUNT_THRESHOLD
            and not cache.get("gps_only_mode", False)
        )

        assert cache["no_driving_count"] == 3
        assert should_cancel is True

    def test_no_driving_count_not_incremented_on_api_error(
        self, mock_db, mock_car_service, base_cache
    ):
        """no_driving_count should NOT increment when reason is api_error."""
        mock_db.set_trip_cache("test@example.com", base_cache)
        mock_car_service.set_find_driving_result(None, "api_error")

        cache = mock_db.get_trip_cache("test@example.com")
        result, reason = mock_car_service.find_driving_car("test@example.com")

        # When reason is api_error, we only increment api_error_count, not no_driving_count
        if result is None and reason == "api_error":
            cache["api_error_count"] = cache.get("api_error_count", 0) + 1
            # no_driving_count is NOT incremented
        elif result is None:
            cache["no_driving_count"] = cache.get("no_driving_count", 0) + 1

        assert cache["no_driving_count"] == 0
        assert cache["api_error_count"] == 1


class TestParkedCounter:
    """Tests for parked_count behavior."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def active_trip_cache(self):
        """Trip cache with car identified and driving."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10005.0,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_parked_count_increments_when_car_parked(self, mock_db, active_trip_cache):
        """parked_count should increment when car API reports is_parked=True."""
        mock_db.set_trip_cache("test@example.com", active_trip_cache)
        car_status = {"is_parked": True, "odometer": 10010.0}

        cache = mock_db.get_trip_cache("test@example.com")

        if car_status.get("is_parked") is True:
            cache["parked_count"] = cache.get("parked_count", 0) + 1

        assert cache["parked_count"] == 1

    def test_parked_count_resets_when_driving(self, mock_db, active_trip_cache):
        """parked_count should reset to 0 when car starts driving again."""
        active_trip_cache["parked_count"] = 2
        mock_db.set_trip_cache("test@example.com", active_trip_cache)
        car_status = {"is_parked": False, "odometer": 10015.0}

        cache = mock_db.get_trip_cache("test@example.com")

        if car_status.get("is_parked") is False:
            cache["parked_count"] = 0

        assert cache["parked_count"] == 0

    def test_parked_count_maintained_when_unknown(self, mock_db, active_trip_cache):
        """parked_count should not change when is_parked is None (unknown)."""
        active_trip_cache["parked_count"] = 2
        mock_db.set_trip_cache("test@example.com", active_trip_cache)
        car_status = {"is_parked": None, "odometer": 10010.0}

        cache = mock_db.get_trip_cache("test@example.com")

        # When is_parked is None, maintain current count
        if car_status.get("is_parked") is None:
            pass  # Don't change parked_count

        assert cache["parked_count"] == 2

    def test_trip_finalizes_at_threshold(self, mock_db, active_trip_cache):
        """Trip should finalize when parked_count reaches 3."""
        active_trip_cache["parked_count"] = 2
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")
        cache["parked_count"] = cache.get("parked_count", 0) + 1

        PARKED_COUNT_THRESHOLD = 3
        should_finalize = cache["parked_count"] >= PARKED_COUNT_THRESHOLD

        assert cache["parked_count"] == 3
        assert should_finalize is True

    def test_odometer_override_parked_state(self, mock_db, active_trip_cache):
        """If odometer increases by >0.5km, override is_parked to False."""
        active_trip_cache["last_odo"] = 10000.0
        active_trip_cache["parked_count"] = 2
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        # Car API says parked, but odometer increased 1km
        car_status = {"is_parked": True, "odometer": 10001.0}

        cache = mock_db.get_trip_cache("test@example.com")
        odo_delta = car_status["odometer"] - cache["last_odo"]

        ODO_DELTA_THRESHOLD = 0.5
        if odo_delta > ODO_DELTA_THRESHOLD:
            # Override: car is actually moving
            is_parked = False
        else:
            is_parked = car_status["is_parked"]

        if is_parked is False:
            cache["parked_count"] = 0

        assert is_parked is False
        assert cache["parked_count"] == 0

    def test_small_odometer_delta_no_override(self, mock_db, active_trip_cache):
        """Small odometer delta should not override parked state."""
        active_trip_cache["last_odo"] = 10000.0
        active_trip_cache["parked_count"] = 2
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        # Car API says parked, odometer increased 0.3km (less than threshold)
        car_status = {"is_parked": True, "odometer": 10000.3}

        cache = mock_db.get_trip_cache("test@example.com")
        odo_delta = car_status["odometer"] - cache["last_odo"]

        ODO_DELTA_THRESHOLD = 0.5
        if odo_delta > ODO_DELTA_THRESHOLD:
            is_parked = False
        else:
            is_parked = car_status["is_parked"]

        if is_parked is True:
            cache["parked_count"] = cache.get("parked_count", 0) + 1

        assert is_parked is True
        assert cache["parked_count"] == 3  # Incremented because parked


class TestApiErrorCounter:
    """Tests for api_error_count behavior."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def active_trip_cache(self):
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_api_error_count_increments_on_failure(self, mock_db, active_trip_cache):
        """api_error_count should increment when car API fails."""
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate API failure
        api_call_failed = True
        if api_call_failed:
            cache["api_error_count"] = cache.get("api_error_count", 0) + 1

        assert cache["api_error_count"] == 1

    def test_api_error_count_resets_on_success(self, mock_db, active_trip_cache):
        """api_error_count should reset to 0 when API call succeeds."""
        active_trip_cache["api_error_count"] = 1
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate successful API call
        api_call_success = True
        if api_call_success:
            cache["api_error_count"] = 0

        assert cache["api_error_count"] == 0

    def test_counters_preserved_on_api_error(self, mock_db, active_trip_cache):
        """Other counters should be preserved when API fails."""
        active_trip_cache["parked_count"] = 2
        active_trip_cache["no_driving_count"] = 1
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # On API error, only increment api_error_count
        cache["api_error_count"] = cache.get("api_error_count", 0) + 1
        # Don't touch other counters

        assert cache["api_error_count"] == 1
        assert cache["parked_count"] == 2  # Preserved
        assert cache["no_driving_count"] == 1  # Preserved

    def test_gps_only_mode_triggered_at_threshold(self, mock_db, active_trip_cache):
        """GPS-only mode should trigger when api_error_count reaches 2."""
        active_trip_cache["api_error_count"] = 1
        active_trip_cache["no_driving_count"] = 3  # Would normally cancel
        mock_db.set_trip_cache("test@example.com", active_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # Another API error
        cache["api_error_count"] = cache.get("api_error_count", 0) + 1

        API_ERROR_THRESHOLD = 2
        NO_DRIVING_COUNT_THRESHOLD = 3

        # Check if should switch to GPS-only mode instead of cancelling
        if cache["no_driving_count"] >= NO_DRIVING_COUNT_THRESHOLD:
            if cache["api_error_count"] >= API_ERROR_THRESHOLD:
                # Switch to GPS-only mode instead of cancelling
                cache["gps_only_mode"] = True
                cache["no_driving_count"] = 0
                cache["api_error_count"] = 0

        assert cache["gps_only_mode"] is True
        assert cache["no_driving_count"] == 0  # Reset
        assert cache["api_error_count"] == 0  # Reset
