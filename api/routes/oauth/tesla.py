"""
Tesla OAuth routes.
"""

import logging
from datetime import datetime, timezone

from fastapi import APIRouter, HTTPException, Header

from auth.dependencies import get_user_from_header
from database import get_db

router = APIRouter(tags=["oauth", "tesla"])
logger = logging.getLogger(__name__)


@router.get("/cars/{car_id}/tesla/auth-url")
def get_tesla_auth_url(car_id: str, callback_url: str, x_user_email: str | None = Header(None)):
    """Get Tesla OAuth authorization URL for user to login."""
    from car_providers import TeslaProvider

    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    email = x_user_email or user_id

    provider = TeslaProvider(email=email)
    auth_url = provider.get_authorization_url(callback_url)

    if not auth_url:
        return {"status": "already_authorized", "auth_url": None}

    # Store email in credentials for later use
    creds_ref = car_ref.collection("credentials").document("api")
    creds_ref.set({
        "brand": "tesla",
        "username": email,
        "password": "",
        "oauth_pending": True,
        "updated_at": datetime.now(tz=timezone.utc).isoformat(),
    }, merge=True)

    return {"status": "authorization_required", "auth_url": auth_url}


@router.post("/cars/{car_id}/tesla/callback")
def complete_tesla_auth(car_id: str, callback_url: str, x_user_email: str | None = Header(None)):
    """Complete Tesla OAuth flow with the callback URL containing the auth code."""
    from car_providers import TeslaProvider

    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Get email from credentials
    creds_doc = car_ref.collection("credentials").document("api").get()
    if not creds_doc.exists:
        raise HTTPException(status_code=400, detail="No pending Tesla authorization")

    creds = creds_doc.to_dict()
    email = creds.get("username", x_user_email or user_id)

    provider = TeslaProvider(email=email)
    success = provider.complete_authorization(callback_url)

    if not success:
        raise HTTPException(status_code=400, detail="Tesla authorization failed")

    # Update credentials to mark as complete
    car_ref.collection("credentials").document("api").update({
        "oauth_pending": False,
        "oauth_completed": True,
        "updated_at": datetime.now(tz=timezone.utc).isoformat(),
    })

    # Update car brand
    car_ref.update({"brand": "tesla"})

    # Try to get vehicle data to confirm it works
    try:
        data = provider.get_data()
        provider.disconnect()
        return {
            "status": "success",
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "battery_level": data.battery_level,
        }
    except Exception as e:
        return {"status": "success", "message": "Authorization complete, but could not fetch vehicle data yet"}
