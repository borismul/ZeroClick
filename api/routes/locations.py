"""
Location routes.
"""

from fastapi import APIRouter, Depends

from models.location import CustomLocation
from services.location_service import location_service
from auth.dependencies import get_current_user

router = APIRouter(prefix="/locations", tags=["locations"])


@router.get("")
def get_locations(user_id: str = Depends(get_current_user)):
    """Get all custom locations."""
    return location_service.get_locations()


@router.post("")
def add_location(loc: CustomLocation, user_id: str = Depends(get_current_user)):
    """Add a custom location (name a place) and update existing trips."""
    return location_service.add_location(loc.name, loc.lat, loc.lng, user_id)


@router.delete("/{name}")
def delete_location(name: str, user_id: str = Depends(get_current_user)):
    """Delete a custom location."""
    return location_service.delete_location(name)
