"""
OAuth routes for car manufacturer authentication.
"""

from .audi import router as audi_router
from .tesla import router as tesla_router
from .vwgroup import router as vwgroup_router
from .renault import router as renault_router

__all__ = [
    "audi_router",
    "tesla_router",
    "vwgroup_router",
    "renault_router",
]
