"""
Stats and export routes.
"""

from fastapi import APIRouter, Depends

from models.export import ExportRequest
from auth.dependencies import get_current_user
from services.export_service import export_service
from services.webhook_service import webhook_service

router = APIRouter(tags=["stats"])


@router.get("/stats")
def get_stats(
    year: int | None = None,
    month: int | None = None,
    car_id: str | None = None,
    user_id: str = Depends(get_current_user),
):
    """Get statistics, optionally filtered by car."""
    return export_service.get_stats(user_id, year, month, car_id)


@router.post("/export")
def export_to_sheet(req: ExportRequest, user_id: str = Depends(get_current_user)):
    """Export trips to Google Sheet."""
    return export_service.export_to_sheets(
        user_id=user_id,
        spreadsheet_id=req.spreadsheet_id,
        year=req.year,
        month=req.month,
        car_id=req.car_id,
        separate_sheets=req.separate_sheets,
    )


@router.get("/audi/compare")
async def compare_odometer(car_id: str | None = None, user_id: str = Depends(get_current_user)):
    """Compare car odometer with calculated trips - returns data for visualization."""
    return export_service.compare_odometer(user_id, car_id)


@router.get("/audi/odometer-now")
def get_current_odometer(user: str):
    """Debug: get current odometer for a user's cars."""
    from database import get_db
    from services.car_service import car_service

    db = get_db()
    cars = car_service.get_cars_with_credentials(user)
    results = []
    for car_info in cars:
        car_doc = db.collection("users").document(user).collection("cars").document(car_info["car_id"]).get()
        car_data = car_doc.to_dict() if car_doc.exists else {}

        status = car_service.check_car_driving_status(car_info)
        if status:
            results.append({
                "car_id": car_info["car_id"],
                "name": status.get("name"),
                "current_odometer": status.get("odometer"),
                "start_odometer": car_data.get("start_odometer", 0),
                "state": status.get("state"),
                "is_parked": status.get("is_parked"),
            })
    return {"cars": results}


@router.get("/audi/check-trip")
def check_stale_trips():
    """Safety net: called periodically to recover stale/orphaned trips."""
    return webhook_service.check_stale_trips()
