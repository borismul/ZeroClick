"""
Google Cloud Secret Manager utilities.

Provides secure access to secrets stored in GCP Secret Manager.
Results are cached to avoid repeated API calls.
Cache is per-process, so secrets refresh on deploy.
"""

import logging
import os
from functools import lru_cache

logger = logging.getLogger(__name__)

# Cache for Secret Manager client
_client = None

# Project ID for secrets
PROJECT_ID = os.environ.get("PROJECT_ID", "mileage-tracker-482013")


def _get_client():
    """Get cached Secret Manager client."""
    global _client
    if _client is None:
        from google.cloud import secretmanager
        _client = secretmanager.SecretManagerServiceClient()
    return _client


@lru_cache(maxsize=50)
def get_secret(secret_id: str, project: str = None) -> str:
    """
    Get secret value from Secret Manager.

    Results are cached to avoid repeated API calls.
    Cache is per-process, so secrets refresh on deploy.

    Args:
        secret_id: The secret ID in Secret Manager
        project: GCP project ID (defaults to PROJECT_ID)

    Returns:
        Secret value as string

    Raises:
        Exception: If secret cannot be retrieved
    """
    if project is None:
        project = PROJECT_ID

    try:
        client = _get_client()
        name = f"projects/{project}/secrets/{secret_id}/versions/latest"
        response = client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")
    except Exception as e:
        logger.error(f"Failed to get secret {secret_id}: {e}")
        raise


def get_secret_or_default(secret_id: str, default: str = "", project: str = None) -> str:
    """
    Get secret with fallback for local development.

    Args:
        secret_id: The secret ID in Secret Manager
        default: Default value if secret cannot be retrieved
        project: GCP project ID (defaults to PROJECT_ID)

    Returns:
        Secret value or default
    """
    try:
        return get_secret(secret_id, project)
    except Exception:
        logger.warning(f"Using default for secret {secret_id}")
        return default


def get_secret_or_env(secret_id: str, env_var: str, default: str = "") -> str:
    """
    Get secret from Secret Manager, falling back to environment variable.

    This is useful for local development where Secret Manager may not be available.

    Args:
        secret_id: The secret ID in Secret Manager
        env_var: Environment variable name to check as fallback
        default: Default value if neither secret nor env var is available

    Returns:
        Secret value, env var value, or default
    """
    # Check env var first for local development
    env_value = os.environ.get(env_var)
    if env_value:
        return env_value

    # Try Secret Manager
    try:
        return get_secret(secret_id)
    except Exception:
        logger.warning(f"Secret {secret_id} not available, using default")
        return default
