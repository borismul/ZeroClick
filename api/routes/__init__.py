"""
FastAPI routes for mileage-tracker API.
"""

from .auth import router as auth_router
from .trips import router as trips_router
from .cars import router as cars_router
from .locations import router as locations_router
from .webhooks import router as webhooks_router
from .stats import router as stats_router
from .charging import router as charging_router

__all__ = [
    "auth_router",
    "trips_router",
    "cars_router",
    "locations_router",
    "webhooks_router",
    "stats_router",
    "charging_router",
]
