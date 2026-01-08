from .base import CarProvider, CarData, VehicleState
from .vwgroup import VWGroupProvider, BRAND_CONNECTORS
from .audi import AudiProvider, AudiAPI, AuthenticationError
from .renault import RenaultProvider
from .tesla import TeslaProvider
from .skoda import SkodaOAuthProvider

# All supported VW Group brands (Audi now uses its own provider)
VW_GROUP_BRANDS = ["audi", "volkswagen", "vw", "skoda", "seat", "cupra"]

__all__ = [
    "CarProvider", "CarData", "VehicleState",
    "VWGroupProvider", "AudiProvider", "AudiAPI", "AuthenticationError",
    "RenaultProvider", "TeslaProvider", "SkodaOAuthProvider",
    "VW_GROUP_BRANDS", "BRAND_CONNECTORS",
]
