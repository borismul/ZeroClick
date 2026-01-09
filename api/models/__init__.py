"""
Pydantic models for mileage-tracker API.
"""

from .trip import (
    TripEvent,
    GpsPoint,
    Trip,
    TripUpdate,
    ManualTrip,
    FullTrip,
)
from .car import (
    Car,
    CarCreate,
    CarUpdate,
    CarCredentials,
    CarTestRequest,
)
from .location import (
    WebhookLocation,
    CustomLocation,
)
from .export import ExportRequest
from .auth import (
    AudiAuthRequest,
    AudiCallbackRequest,
    VWGroupAuthRequest,
    VWGroupCallbackRequest,
    RenaultAuthRequest,
    RenaultCallbackRequest,
    RenaultLoginRequest,
)

__all__ = [
    # Trip models
    "TripEvent",
    "GpsPoint",
    "Trip",
    "TripUpdate",
    "ManualTrip",
    "FullTrip",
    # Car models
    "Car",
    "CarCreate",
    "CarUpdate",
    "CarCredentials",
    "CarTestRequest",
    # Location models
    "WebhookLocation",
    "CustomLocation",
    # Export models
    "ExportRequest",
    # Auth models
    "AudiAuthRequest",
    "AudiCallbackRequest",
    "VWGroupAuthRequest",
    "VWGroupCallbackRequest",
    "RenaultAuthRequest",
    "RenaultCallbackRequest",
    "RenaultLoginRequest",
]
