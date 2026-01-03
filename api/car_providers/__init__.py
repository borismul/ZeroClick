from .base import CarProvider, CarData
from .vwgroup import VWGroupProvider, AudiProvider, BRAND_CONNECTORS
from .renault import RenaultProvider
from .tesla import TeslaProvider

# All supported VW Group brands
VW_GROUP_BRANDS = ["audi", "volkswagen", "vw", "skoda", "seat", "cupra"]

__all__ = ["CarProvider", "CarData", "VWGroupProvider", "AudiProvider", "RenaultProvider", "TeslaProvider", "VW_GROUP_BRANDS", "BRAND_CONNECTORS"]
