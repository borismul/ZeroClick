"""Mock car provider for testing."""

from typing import Any


class MockCarProvider:
    """Mock car provider that simulates car API behavior.

    This mock implements the basic interface of CarProvider for testing
    webhook service logic without real car API calls.
    """

    def __init__(self):
        self._connected = False
        self._data = {}
        self._odometer: int | None = None
        self._is_parked: bool = True
        self._should_error: bool = False

    async def connect(self) -> None:
        """Simulate connecting to car API."""
        if self._should_error:
            raise Exception("Mock connection error")
        self._connected = True

    async def disconnect(self) -> None:
        """Simulate disconnecting from car API."""
        self._connected = False

    async def get_data(self) -> dict[str, Any]:
        """Get mock car data."""
        if self._should_error:
            raise Exception("Mock API error")
        return self._data

    async def get_odometer(self) -> int | None:
        """Get mock odometer reading."""
        if self._should_error:
            raise Exception("Mock odometer error")
        return self._odometer

    def is_parked(self) -> bool:
        """Check if car is parked."""
        return self._is_parked

    # === Test Helper Methods ===

    def set_odometer(self, value: int) -> None:
        """Set mock odometer value."""
        self._odometer = value

    def set_parked(self, parked: bool) -> None:
        """Set whether car is parked."""
        self._is_parked = parked

    def set_driving(self) -> None:
        """Convenience method to set car as driving."""
        self._is_parked = False

    def set_error_mode(self, should_error: bool) -> None:
        """Configure mock to raise errors on API calls."""
        self._should_error = should_error

    def set_data(self, data: dict) -> None:
        """Set mock car data."""
        self._data = data

    def reset(self) -> None:
        """Reset mock to default state."""
        self._connected = False
        self._data = {}
        self._odometer = None
        self._is_parked = True
        self._should_error = False
