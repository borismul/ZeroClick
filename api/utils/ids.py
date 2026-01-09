"""
ID generation utilities.
"""

import random
import string
from datetime import datetime


def generate_id() -> str:
    """
    Generate a unique trip ID in format: YYYYMMDD-HHMM-XXX

    Returns:
        Unique ID string like "20250109-1430-ABC"
    """
    now = datetime.now()
    rand = "".join(random.choices(string.ascii_uppercase, k=3))
    return f"{now.strftime('%Y%m%d-%H%M')}-{rand}"
