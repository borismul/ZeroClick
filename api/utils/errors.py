"""
Secure error handling utilities.

Provides helpers to log detailed error information internally
while returning generic messages to clients (preventing information leakage).
"""

import logging

from fastapi import HTTPException

logger = logging.getLogger(__name__)


def auth_error(internal_message: str, exception: Exception = None) -> HTTPException:
    """
    Log detailed auth error internally, return generic message to client.

    Args:
        internal_message: Detailed message for internal logging
        exception: Optional exception to include in logs

    Returns:
        HTTPException with generic message
    """
    if exception:
        logger.error(f"{internal_message}: {exception}", exc_info=True)
    else:
        logger.error(internal_message)
    return HTTPException(status_code=401, detail="Authentication failed")


def oauth_error(internal_message: str, exception: Exception = None) -> HTTPException:
    """
    Log detailed OAuth error internally, return generic message to client.

    Args:
        internal_message: Detailed message for internal logging
        exception: Optional exception to include in logs

    Returns:
        HTTPException with generic message
    """
    if exception:
        logger.error(f"{internal_message}: {exception}", exc_info=True)
    else:
        logger.error(internal_message)
    return HTTPException(status_code=400, detail="OAuth flow failed")


def validation_error(internal_message: str, user_message: str = "Invalid request") -> HTTPException:
    """
    Log validation error internally, return user-friendly message.

    Args:
        internal_message: Detailed message for internal logging
        user_message: Message to show to user

    Returns:
        HTTPException with user message
    """
    logger.warning(internal_message)
    return HTTPException(status_code=400, detail=user_message)


def server_error(internal_message: str, exception: Exception = None) -> HTTPException:
    """
    Log server error internally, return generic message to client.

    Args:
        internal_message: Detailed message for internal logging
        exception: Optional exception to include in logs

    Returns:
        HTTPException with generic message
    """
    if exception:
        logger.error(f"{internal_message}: {exception}", exc_info=True)
    else:
        logger.error(internal_message)
    return HTTPException(status_code=500, detail="Internal server error")
