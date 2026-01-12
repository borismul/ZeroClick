"""
Renault OAuth routes (Gigya-based).
"""

import secrets
import logging
import asyncio
from datetime import datetime, timezone, timedelta

import aiohttp
import requests as req
from fastapi import APIRouter, HTTPException, Depends

from models.auth import RenaultAuthRequest, RenaultCallbackRequest, RenaultLoginRequest
from config import RENAULT_GIGYA_CONFIG, RENAULT_GIGYA_API_KEYS
from auth.dependencies import get_current_user
from database import get_db

router = APIRouter(prefix="/renault/auth", tags=["oauth", "renault"])
logger = logging.getLogger(__name__)


@router.post("/login")
def renault_direct_login(request: RenaultLoginRequest, user_id: str = Depends(get_current_user)):
    """Direct Renault login via Gigya API (username/password)."""
    db = get_db()

    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    api_key = RENAULT_GIGYA_API_KEYS.get(request.locale, RENAULT_GIGYA_API_KEYS["nl_NL"])
    gigya_url = "https://accounts.eu1.gigya.com"

    try:
        # Step 1: Login to Gigya
        login_resp = req.post(
            f"{gigya_url}/accounts.login",
            data={
                "ApiKey": api_key,
                "loginID": request.username,
                "password": request.password,
            },
        )
        login_data = login_resp.json()

        if login_data.get("errorCode", 0) != 0:
            error_msg = login_data.get("errorMessage", "Login failed")
            logger.error(f"Renault Gigya login failed: {error_msg}")
            raise HTTPException(status_code=401, detail=error_msg)

        login_token = login_data.get("sessionInfo", {}).get("cookieValue")
        if not login_token:
            login_token = login_data.get("sessionInfo", {}).get("login_token")
        if not login_token:
            raise HTTPException(status_code=400, detail="No login token received from Gigya")

        # Step 2: Get account info
        account_resp = req.post(
            f"{gigya_url}/accounts.getAccountInfo",
            data={
                "ApiKey": api_key,
                "login_token": login_token,
            },
        )
        account_data = account_resp.json()

        if account_data.get("errorCode", 0) != 0:
            raise HTTPException(status_code=400, detail=f"Failed to get account info: {account_data.get('errorMessage')}")

        person_id = account_data.get("data", {}).get("personId")

        # Step 3: Get JWT
        jwt_resp = req.post(
            f"{gigya_url}/accounts.getJWT",
            data={
                "ApiKey": api_key,
                "login_token": login_token,
                "fields": "data.personId,data.gigyaDataCenter",
                "expiration": 900,
            },
        )
        jwt_data = jwt_resp.json()

        if jwt_data.get("errorCode", 0) != 0:
            raise HTTPException(status_code=400, detail=f"Failed to get JWT: {jwt_data.get('errorMessage')}")

        gigya_jwt = jwt_data.get("id_token")

        # Store tokens
        tokens = {
            "brand": "renault",
            "gigya_token": login_token,
            "gigya_jwt": gigya_jwt,
            "gigya_person_id": person_id,
            "locale": request.locale,
            "oauth_completed": True,
            "expires_at": (datetime.now(tz=timezone.utc) + timedelta(seconds=900)).isoformat(),
            "updated_at": datetime.now(tz=timezone.utc).isoformat(),
        }

        car_ref.collection("credentials").document("api").set(tokens, merge=True)

        logger.info(f"Renault login completed for car {request.car_id}, user {user_id}")

        return {
            "status": "success",
            "brand": "renault",
            "message": "MY Renault connected successfully",
            "person_id": person_id,
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Renault login failed: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/url")
def get_renault_auth_url(request: RenaultAuthRequest, user_id: str = Depends(get_current_user)):
    """Generate Renault ID Connect login URL for webview."""
    db = get_db()

    # Verify car exists
    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Generate state for tracking
    state = secrets.token_urlsafe(32)

    # Store state in Firestore
    car_ref.collection("credentials").document("oauth_state").set({
        "state": state,
        "locale": request.locale,
        "created_at": datetime.now(tz=timezone.utc).isoformat(),
    })

    # Build the login URL
    login_url = RENAULT_GIGYA_CONFIG["login_url"].format(locale=request.locale)
    success_url = RENAULT_GIGYA_CONFIG["success_url"].format(locale=request.locale)

    logger.info(f"Generated Renault login URL for car {request.car_id}")
    return {
        "auth_url": login_url,
        "success_url": success_url,
        "gigya_api_key": RENAULT_GIGYA_CONFIG["api_key"],
        "state": state,
    }


@router.post("/callback")
def handle_renault_callback(request: RenaultCallbackRequest, user_id: str = Depends(get_current_user)):
    """Handle Renault OAuth callback - store Gigya tokens and get JWT."""
    db = get_db()

    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    try:
        # Get JWT from Gigya using the login token
        async def get_gigya_jwt():
            async with aiohttp.ClientSession() as session:
                # Get account info first to get person_id
                account_url = f"{RENAULT_GIGYA_CONFIG['gigya_url']}/accounts.getAccountInfo"
                account_data = {
                    "ApiKey": RENAULT_GIGYA_CONFIG["api_key"],
                    "login_token": request.gigya_token,
                }
                async with session.post(account_url, data=account_data) as resp:
                    account_info = await resp.json()
                    if account_info.get("errorCode", 0) != 0:
                        raise Exception(f"Gigya account info failed: {account_info.get('errorMessage')}")

                person_id = account_info.get("data", {}).get("personId")
                if not person_id and request.gigya_person_id:
                    person_id = request.gigya_person_id

                # Get JWT token
                jwt_url = f"{RENAULT_GIGYA_CONFIG['gigya_url']}/accounts.getJWT"
                jwt_data = {
                    "ApiKey": RENAULT_GIGYA_CONFIG["api_key"],
                    "login_token": request.gigya_token,
                    "fields": "data.personId,data.gigyaDataCenter",
                    "expiration": 900,
                }
                async with session.post(jwt_url, data=jwt_data) as resp:
                    jwt_info = await resp.json()
                    if jwt_info.get("errorCode", 0) != 0:
                        raise Exception(f"Gigya JWT failed: {jwt_info.get('errorMessage')}")

                return {
                    "jwt": jwt_info.get("id_token"),
                    "person_id": person_id,
                    "account_info": account_info,
                }

        result = asyncio.run(get_gigya_jwt())

        # Store tokens
        tokens = {
            "brand": "renault",
            "gigya_token": request.gigya_token,
            "gigya_jwt": result["jwt"],
            "gigya_person_id": result["person_id"],
            "oauth_completed": True,
            "expires_at": (datetime.now(tz=timezone.utc) + timedelta(seconds=900)).isoformat(),
            "updated_at": datetime.now(tz=timezone.utc).isoformat(),
        }

        car_ref.collection("credentials").document("api").set(tokens, merge=True)

        # Clean up state doc
        car_ref.collection("credentials").document("oauth_state").delete()

        logger.info(f"Renault OAuth completed for car {request.car_id}, user {user_id}")

        return {
            "status": "success",
            "brand": "renault",
            "message": "MY Renault connected successfully",
        }

    except Exception as e:
        logger.error(f"Renault OAuth failed: {e}")
        raise HTTPException(status_code=400, detail=str(e))
