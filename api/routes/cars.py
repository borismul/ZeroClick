"""
Car management routes.
"""

from fastapi import APIRouter, HTTPException, Header

from models.car import Car, CarCreate, CarUpdate, CarCredentials
from auth.dependencies import get_user_from_header
from services.car_service import car_service

router = APIRouter(prefix="/cars", tags=["cars"])


@router.get("")
def list_cars(x_user_email: str | None = Header(None)) -> list[Car]:
    """List all cars for the user."""
    user_id = get_user_from_header(x_user_email)
    return car_service.get_cars(user_id)


@router.post("")
def create_car(car: CarCreate, x_user_email: str | None = Header(None)):
    """Create a new car."""
    user_id = get_user_from_header(x_user_email)
    return car_service.create_car(
        user_id=user_id,
        name=car.name,
        brand=car.brand,
        color=car.color,
        icon=car.icon,
        start_odometer=car.start_odometer,
    )


@router.get("/{car_id}")
def get_car(car_id: str, x_user_email: str | None = Header(None)):
    """Get a single car."""
    user_id = get_user_from_header(x_user_email)
    car = car_service.get_car(user_id, car_id)
    if not car:
        raise HTTPException(status_code=404, detail="Car not found")
    return car


@router.patch("/{car_id}")
def update_car(car_id: str, update: CarUpdate, x_user_email: str | None = Header(None)):
    """Update a car."""
    user_id = get_user_from_header(x_user_email)
    result = car_service.update_car(user_id, car_id, update.model_dump(exclude_unset=True))
    if not result:
        raise HTTPException(status_code=404, detail="Car not found")
    return result


@router.delete("/{car_id}")
def delete_car(car_id: str, x_user_email: str | None = Header(None)):
    """Delete a car (trips remain but car_id becomes null)."""
    user_id = get_user_from_header(x_user_email)
    result = car_service.delete_car(user_id, car_id)
    if not result:
        raise HTTPException(status_code=404, detail="Car not found")
    if result.get("error"):
        raise HTTPException(status_code=400, detail=result["error"])
    return result


@router.put("/{car_id}/credentials")
def save_car_credentials(car_id: str, creds: CarCredentials, x_user_email: str | None = Header(None)):
    """Save API credentials for a specific car."""
    user_id = get_user_from_header(x_user_email)
    result = car_service.save_car_credentials(user_id, car_id, creds.model_dump())
    if not result:
        raise HTTPException(status_code=404, detail="Car not found")
    return result


@router.get("/{car_id}/credentials")
def get_car_credentials(car_id: str, x_user_email: str | None = Header(None)):
    """Get credentials status for a specific car (not the actual password)."""
    user_id = get_user_from_header(x_user_email)
    result = car_service.get_car_credentials_status(user_id, car_id)
    if not result:
        raise HTTPException(status_code=404, detail="Car not found")
    if result.get("error"):
        raise HTTPException(status_code=404, detail=result["error"])
    return result


@router.delete("/{car_id}/credentials")
def delete_car_credentials(car_id: str, x_user_email: str | None = Header(None)):
    """Delete/logout credentials for a specific car."""
    user_id = get_user_from_header(x_user_email)
    result = car_service.delete_car_credentials(user_id, car_id)
    if not result:
        raise HTTPException(status_code=404, detail="Car not found")
    return result


@router.post("/{car_id}/credentials/test")
def test_car_credentials(car_id: str, creds: CarCredentials, x_user_email: str | None = Header(None)):
    """Test car API credentials before saving."""
    from car_providers import AudiProvider, VWGroupProvider, RenaultProvider, VW_GROUP_BRANDS

    user_id = get_user_from_header(x_user_email)
    car = car_service.get_car(user_id, car_id)
    if not car:
        raise HTTPException(status_code=404, detail="Car not found")

    try:
        if creds.brand == "renault":
            provider = RenaultProvider(
                username=creds.username,
                password=creds.password,
                locale=creds.locale or "nl_NL",
            )
        elif creds.brand == "audi":
            provider = AudiProvider(
                username=creds.username,
                password=creds.password,
                country=creds.country or "NL",
            )
        elif creds.brand in VW_GROUP_BRANDS:
            provider = VWGroupProvider(
                brand=creds.brand,
                username=creds.username,
                password=creds.password,
                country=creds.country or "NL",
                spin=creds.spin,
            )
        else:
            raise HTTPException(status_code=400, detail=f"Unsupported brand: {creds.brand}")

        data = provider.get_data()
        provider.disconnect()

        return {
            "status": "success",
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "battery_level": data.battery_level,
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Connection failed: {str(e)}")


@router.get("/{car_id}/stats")
def get_car_statistics(car_id: str, x_user_email: str | None = Header(None)):
    """Get detailed statistics for a car."""
    from google.cloud import firestore
    from database import get_db

    user_id = get_user_from_header(x_user_email)
    car = car_service.get_car(user_id, car_id)
    if not car:
        raise HTTPException(status_code=404, detail="Car not found")

    db = get_db()
    trips = db.collection("trips").where(
        filter=firestore.FieldFilter("user_id", "==", user_id)
    ).where(
        filter=firestore.FieldFilter("car_id", "==", car_id)
    ).stream()

    total_trips = 0
    total_km = 0.0
    business_km = 0.0
    private_km = 0.0

    for trip in trips:
        data = trip.to_dict()
        total_trips += 1
        total_km += data.get("distance_km", 0)
        business_km += data.get("business_km", 0)
        private_km += data.get("private_km", 0)

    return {
        "car_id": car_id,
        "trip_count": total_trips,
        "total_km": round(total_km, 1),
        "business_km": round(business_km, 1),
        "private_km": round(private_km, 1),
    }
