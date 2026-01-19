"""Mock implementations for testing."""

from .mock_firestore import MockFirestore
from .mock_car_provider import MockCarProvider, MockCarService

__all__ = ["MockFirestore", "MockCarProvider", "MockCarService"]
