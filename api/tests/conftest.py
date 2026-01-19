"""Pytest fixtures for API tests."""

import pytest
from unittest.mock import Mock, patch
from tests.mocks.mock_firestore import MockFirestore
from tests.mocks.mock_car_provider import MockCarProvider


@pytest.fixture
def mock_db():
    """Provide a mock Firestore database."""
    return MockFirestore()


@pytest.fixture
def mock_car_provider():
    """Provide a mock car provider."""
    return MockCarProvider()


@pytest.fixture
def sample_user_id():
    """Standard test user ID."""
    return "test@example.com"


@pytest.fixture
def sample_car_id():
    """Standard test car ID."""
    return "car-test-123"


@pytest.fixture
def sample_trip_cache():
    """Sample trip cache for testing."""
    return {
        "active": True,
        "user_id": "test@example.com",
        "car_id": "car-test-123",
        "car_name": "Test Car",
        "start_time": "2024-01-19T10:00:00Z",
        "start_odo": None,
        "last_odo": None,
        "no_driving_count": 0,
        "parked_count": 0,
        "api_error_count": 0,
        "skip_pause_count": 0,
        "gps_events": [],
        "gps_trail": [],
        "gps_only_mode": False,
        "end_triggered": None,
    }
