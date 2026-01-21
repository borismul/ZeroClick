"""
Webhook routes for trip tracking.
"""

import logging
from fastapi import APIRouter, HTTPException, Header, Request

from models.location import WebhookLocation
from services.webhook_service import webhook_service
from services.token_service import token_service
from slowapi import Limiter
from slowapi.util import get_remote_address

router = APIRouter(prefix="/webhook", tags=["webhooks"])
logger = logging.getLogger(__name__)

# Rate limiter for webhook endpoints
limiter = Limiter(key_func=get_remote_address)


def get_webhook_user(authorization: str | None = None) -> str:
    """
    Get user from Bearer token (required).

    Args:
        authorization: Authorization header value

    Returns:
        User email

    Raises:
        HTTPException: If no valid Bearer token provided
    """
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Bearer token required")

    token = authorization[7:]
    try:
        payload = token_service.verify_access_token(token)
        if payload and payload.get("email"):
            return payload["email"]
    except Exception as e:
        logger.warning(f"Bearer token verification failed: {e}")

    raise HTTPException(status_code=401, detail="Invalid or expired token")


@router.post("/ping")
@limiter.limit("120/minute")
def webhook_ping(
    request: Request,
    loc: WebhookLocation,
    car_id: str | None = None,
    device_id: str | None = None,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """GPS ping during trip. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.handle_ping(user_id, loc.lat, loc.lng, car_id, device_id)


@router.post("/start")
@limiter.limit("10/minute")
def webhook_start(
    request: Request,
    loc: WebhookLocation,
    car_id: str | None = None,
    device_id: str | None = None,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """Trip start. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.handle_start(user_id, loc.lat, loc.lng, car_id, device_id)


@router.post("/end")
@limiter.limit("10/minute")
def webhook_end(
    request: Request,
    loc: WebhookLocation,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """Trip end. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.handle_end(user_id, loc.lat, loc.lng)


@router.post("/finalize")
@limiter.limit("10/minute")
def webhook_finalize(
    request: Request,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """Force finalize a pending trip. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.handle_finalize(user_id)


@router.post("/cancel")
@limiter.limit("10/minute")
def webhook_cancel(
    request: Request,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """Cancel the current trip. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.handle_cancel(user_id)


@router.get("/status")
@limiter.limit("60/minute")
def webhook_status(
    request: Request,
    authorization: str | None = Header(None, alias="Authorization"),
):
    """Check current trip status. Requires Bearer token."""
    user_id = get_webhook_user(authorization)
    return webhook_service.get_status(user_id)
