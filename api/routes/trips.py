"""
Trip routes.
"""

from collections.abc import Sequence
from typing import Any

from fastapi import APIRouter, HTTPException, Query, Depends
from pydantic import BaseModel

from models.trip import Trip, TripUpdate, ManualTrip, FullTrip
from auth.dependencies import get_current_user
from services.trip_service import trip_service

router = APIRouter(prefix="/trips", tags=["trips"])


class TripsResponse(BaseModel):
    """Response for trips list with cursor pagination."""
    trips: list[Trip]
    next_cursor: str | None = None


@router.get("")
def get_trips(
    year: int | None = None,
    month: int | None = None,
    car_id: str | None = None,
    cursor: str | None = None,
    page: int | None = Query(default=None, ge=1),
    limit: int = Query(default=50, le=100),
    user_id: str = Depends(get_current_user),
) -> TripsResponse | Sequence[Trip]:
    """
    Get trips with optional filtering, sorted by date/time descending.

    Supports two pagination modes:
    - Cursor-based (preferred): Use `cursor` parameter for efficient pagination
    - Legacy page-based: Use `page` parameter (deprecated, less efficient)

    Returns TripsResponse with next_cursor for cursor-based, or list of trips for legacy.
    """
    if page is not None:
        # Legacy mode: page-based pagination (for backwards compatibility)
        return trip_service.get_trips_legacy(user_id, year, month, car_id, page, limit)

    # Cursor-based pagination (efficient)
    trips, next_cursor = trip_service.get_trips(user_id, year, month, car_id, cursor, limit)
    return TripsResponse(trips=list(trips), next_cursor=next_cursor)


@router.post("", response_model=Trip)
def create_trip(trip: ManualTrip, user_id: str = Depends(get_current_user)):
    """Create a manual trip."""
    return trip_service.create_manual_trip(
        user_id=user_id,
        date=trip.date,
        from_address=trip.from_address,
        to_address=trip.to_address,
        distance_km=trip.distance_km,
        trip_type=trip.trip_type,
        start_time=trip.start_time,
        end_time=trip.end_time,
        car_id=trip.car_id,
    )


@router.post("/full")
def create_full_trip(trip: FullTrip, user: str | None = None):
    """Create a trip with full details including GPS trail (public endpoint for recovery)."""
    if not user:
        raise HTTPException(status_code=401, detail="User parameter required")
    return trip_service.create_full_trip(
        user_id=user,
        date=trip.date,
        start_time=trip.start_time,
        end_time=trip.end_time,
        from_lat=trip.from_lat,
        from_lon=trip.from_lon,
        to_lat=trip.to_lat,
        to_lon=trip.to_lon,
        distance_km=trip.distance_km,
        start_odo=trip.start_odo,
        end_odo=trip.end_odo,
        trip_type=trip.trip_type,
        car_id=trip.car_id,
        gps_trail=[{"lat": p.lat, "lng": p.lng, "timestamp": p.timestamp} for p in trip.gps_trail],
    )


@router.get("/{trip_id}", response_model=Trip)
def get_trip(trip_id: str):
    """Get single trip."""
    trip = trip_service.get_trip(trip_id)
    if not trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    return trip


@router.patch("/{trip_id}", response_model=Trip)
def update_trip(trip_id: str, update: TripUpdate):
    """Update trip fields."""
    updates = update.model_dump(exclude_unset=True)
    trip = trip_service.update_trip(trip_id, updates)
    if not trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    return trip


@router.delete("/{trip_id}")
def delete_trip(trip_id: str):
    """Delete a trip."""
    if not trip_service.delete_trip(trip_id):
        raise HTTPException(status_code=404, detail="Trip not found")
    return {"status": "deleted"}
