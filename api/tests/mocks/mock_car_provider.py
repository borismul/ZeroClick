"""Mock car provider for testing car detection and status checks."""

from typing import Any
from car_providers.base import CarProvider, CarData, VehicleState


class MockCarProvider(CarProvider):
    """Mock implementation of CarProvider for testing.

    Allows tests to control:
    - Whether car is driving/parked/unknown
    - Odometer readings
    - GPS coordinates
    - API errors
    """

    def __init__(self, brand: str = "mock"):
        self._brand = brand
        self._is_connected = False
        self._should_fail = False
        self._fail_message = "Mock API error"

        # Configurable state
        self._is_parked: bool | None = True
        self._is_driving: bool = False
        self._state: VehicleState = VehicleState.PARKED
        self._odometer: float = 10000.0
        self._lat: float | None = None
        self._lng: float | None = None

    @property
    def brand(self) -> str:
        return self._brand

    # === Test Setup Methods ===

    def set_driving(self, odometer: float = 10000.0, lat: float = 51.9, lng: float = 4.4):
        """Configure car as currently driving."""
        self._is_parked = False
        self._is_driving = True
        self._state = VehicleState.DRIVING
        self._odometer = odometer
        self._lat = lat
        self._lng = lng

    def set_parked(self, odometer: float = 10000.0, lat: float = 51.9, lng: float = 4.4):
        """Configure car as parked."""
        self._is_parked = True
        self._is_driving = False
        self._state = VehicleState.PARKED
        self._odometer = odometer
        self._lat = lat
        self._lng = lng

    def set_unknown(self):
        """Configure car state as unknown (API returned but no clear status)."""
        self._is_parked = None
        self._is_driving = False
        self._state = VehicleState.UNKNOWN

    def set_odometer(self, value: float):
        """Update odometer reading."""
        self._odometer = value

    def set_should_fail(self, fail: bool = True, message: str = "Mock API error"):
        """Configure API to return errors."""
        self._should_fail = fail
        self._fail_message = message

    def set_error_mode(self, should_error: bool) -> None:
        """Configure mock to raise errors on API calls (alias for set_should_fail)."""
        self._should_fail = should_error

    def reset(self):
        """Reset to default state."""
        self._is_connected = False
        self._should_fail = False
        self._is_parked = True
        self._is_driving = False
        self._state = VehicleState.PARKED
        self._odometer = 10000.0
        self._lat = None
        self._lng = None

    # === CarProvider Interface ===

    def connect(self) -> bool:
        if self._should_fail:
            raise Exception(self._fail_message)
        self._is_connected = True
        return True

    def disconnect(self) -> None:
        self._is_connected = False

    def get_data(self) -> CarData:
        if self._should_fail:
            raise Exception(self._fail_message)

        return CarData(
            vin="MOCK123456789",
            odometer_km=self._odometer,
            latitude=self._lat,
            longitude=self._lng,
            state=self._state,
            raw_data={
                "car_id": "mock-car-id",
                "name": "Mock Car",
                "is_parked": self._is_parked,
                "is_driving": self._is_driving,
            },
        )

    def get_odometer(self) -> float | None:
        if self._should_fail:
            raise Exception(self._fail_message)
        return self._odometer

    def is_parked(self) -> bool | None:
        """Check if car is parked."""
        return self._is_parked

    # === Legacy dict-based interface for tests ===

    def get_dict_data(self) -> dict[str, Any]:
        """Get mock car data as dict (for tests expecting dict format)."""
        if self._should_fail:
            raise Exception(self._fail_message)

        return {
            "car_id": "mock-car-id",
            "name": "Mock Car",
            "is_parked": self._is_parked,
            "is_driving": self._is_driving,
            "state": self._state.value,
            "odometer": self._odometer,
            "lat": self._lat,
            "lng": self._lng,
        }


class MockCarService:
    """Mock car service for testing find_driving_car behavior."""

    def __init__(self):
        self._cars: dict[str, MockCarProvider] = {}
        self._find_driving_result: tuple[dict | None, str] | None = None
        self._check_status_result: dict | None = None
        self._should_fail = False

    # === Test Setup ===

    def add_car(self, car_id: str, provider: MockCarProvider):
        """Add a car with its mock provider."""
        self._cars[car_id] = provider

    def set_find_driving_result(self, result: dict | None, reason: str):
        """Set the result of find_driving_car."""
        self._find_driving_result = (result, reason)

    def set_check_status_result(self, result: dict | None):
        """Set the result of check_car_driving_status."""
        self._check_status_result = result

    def set_should_fail(self, fail: bool = True):
        """Make all car API calls fail."""
        self._should_fail = fail
        for provider in self._cars.values():
            provider.set_should_fail(fail)

    def reset(self):
        """Reset all state."""
        self._cars.clear()
        self._find_driving_result = None
        self._check_status_result = None
        self._should_fail = False

    # === Mock Service Methods ===

    def find_driving_car(self, user_id: str) -> tuple[dict | None, str]:
        """Mock implementation of find_driving_car."""
        if self._find_driving_result is not None:
            return self._find_driving_result

        if self._should_fail:
            return None, "api_error"

        if not self._cars:
            return None, "no_cars"

        # Check each car
        for car_id, provider in self._cars.items():
            if provider._is_driving:
                return {
                    "car_id": car_id,
                    "name": "Mock Car",
                    "is_parked": False,
                    "is_driving": True,
                    "odometer": provider._odometer,
                    "lat": provider._lat,
                    "lng": provider._lng,
                }, "driving"

        return None, "parked"

    def check_car_driving_status(self, car_info: dict) -> dict | None:
        """Mock implementation of check_car_driving_status."""
        if self._check_status_result is not None:
            return self._check_status_result

        if self._should_fail:
            return None

        car_id = car_info.get("car_id")
        if car_id in self._cars:
            provider = self._cars[car_id]
            return {
                "car_id": car_id,
                "name": "Mock Car",
                "is_parked": provider._is_parked,
                "is_driving": provider._is_driving,
                "state": provider._state.value,
                "odometer": provider._odometer,
            }

        return None
