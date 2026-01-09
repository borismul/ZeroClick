"""
Location routes.
"""

from fastapi import APIRouter

from models.location import CustomLocation
from services.location_service import location_service

router = APIRouter(prefix="/locations", tags=["locations"])


@router.get("")
def get_locations():
    """Get all custom locations."""
    return location_service.get_locations()


@router.post("")
def add_location(loc: CustomLocation):
    """Add a custom location (name a place) and update existing trips."""
    return location_service.add_location(loc.name, loc.lat, loc.lng)


@router.delete("/{name}")
def delete_location(name: str):
    """Delete a custom location."""
    return location_service.delete_location(name)
