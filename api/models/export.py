"""
Export-related Pydantic models.
"""

from pydantic import BaseModel


class ExportRequest(BaseModel):
    """Request to export trips to Google Sheets."""
    spreadsheet_id: str
    year: int | None = None
    month: int | None = None
    car_id: str | None = None  # Filter by specific car
    separate_sheets: bool = False  # Create separate sheets per car
