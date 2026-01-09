"""
Export service - stats and Google Sheets export.
"""

import re
import logging
from datetime import datetime

from google.cloud import firestore
from google.auth import default
from googleapiclient.discovery import build

from database import get_db
from .car_service import car_service

logger = logging.getLogger(__name__)


class ExportService:
    """Service for stats and export operations."""

    def get_stats(
        self,
        user_id: str,
        year: int | None = None,
        month: int | None = None,
        car_id: str | None = None,
    ) -> dict:
        """Get statistics, optionally filtered by car."""
        db = get_db()
        query = db.collection("trips").where(filter=firestore.FieldFilter("user_id", "==", user_id))

        if year and month:
            start_dt = datetime(year, month, 1)
            end_dt = datetime(year + 1, 1, 1) if month == 12 else datetime(year, month + 1, 1)
            query = query.where(filter=firestore.FieldFilter("created_at", ">=", start_dt.isoformat()))
            query = query.where(filter=firestore.FieldFilter("created_at", "<", end_dt.isoformat()))

        total_km = 0.0
        business_km = 0.0
        private_km = 0.0
        trip_count = 0

        for doc in query.stream():
            data = doc.to_dict()
            if car_id and data.get("car_id") != car_id:
                continue
            total_km += data.get("distance_km", 0)
            business_km += data.get("business_km", 0)
            private_km += data.get("private_km", 0)
            trip_count += 1

        return {
            "total_km": round(total_km, 1),
            "business_km": round(business_km, 1),
            "private_km": round(private_km, 1),
            "trip_count": trip_count,
        }

    def export_to_sheets(
        self,
        user_id: str,
        spreadsheet_id: str,
        year: int | None = None,
        month: int | None = None,
        car_id: str | None = None,
        separate_sheets: bool = False,
    ) -> dict:
        """Export trips to Google Sheet."""
        # Extract spreadsheet ID from URL if full URL provided
        if "docs.google.com" in spreadsheet_id:
            match = re.search(r"/d/([a-zA-Z0-9-_]+)", spreadsheet_id)
            if match:
                spreadsheet_id = match.group(1)
            else:
                return {"error": "Invalid spreadsheet URL"}

        creds, _ = default(scopes=["https://www.googleapis.com/auth/spreadsheets"])
        sheets = build("sheets", "v4", credentials=creds)

        db = get_db()

        # Build car name lookup map
        car_names = {}
        cars_ref = db.collection("users").document(user_id).collection("cars")
        for car_doc in cars_ref.stream():
            car_data = car_doc.to_dict()
            car_names[car_doc.id] = car_data.get("name", car_doc.id)

        # Query trips
        query = db.collection("trips").order_by("created_at")

        if year and month:
            start_dt = datetime(year, month, 1)
            end_dt = datetime(year + 1, 1, 1) if month == 12 else datetime(year, month + 1, 1)
            query = query.where(filter=firestore.FieldFilter("created_at", ">=", start_dt.isoformat()))
            query = query.where(filter=firestore.FieldFilter("created_at", "<", end_dt.isoformat()))

        docs = list(query.stream())

        # Filter by car_id if specified
        if car_id:
            docs = [doc for doc in docs if doc.to_dict().get("car_id") == car_id]

        headers = [
            "ID", "Datum", "Vertrektijd", "Aankomsttijd", "Van", "Naar",
            "Van Lat", "Van Lon", "Naar Lat", "Naar Lon",
            "Afstand (km)", "Type", "Zakelijk (km)", "Privé (km)",
            "Begin km-stand", "Eind km-stand", "Auto", "Notities", "Aangemaakt",
        ]

        def build_row(d: dict) -> list:
            car_id_val = d.get("car_id", "")
            car_name = car_names.get(car_id_val, car_id_val) if car_id_val else ""
            return [
                d.get("id", ""),
                d.get("date", ""),
                d.get("start_time", ""),
                d.get("end_time", ""),
                d.get("from_address", ""),
                d.get("to_address", ""),
                d.get("from_lat", ""),
                d.get("from_lon", ""),
                d.get("to_lat", ""),
                d.get("to_lon", ""),
                d.get("distance_km", 0),
                d.get("trip_type", ""),
                d.get("business_km", 0),
                d.get("private_km", 0),
                d.get("start_odo", 0),
                d.get("end_odo", 0),
                car_name,
                d.get("notes", ""),
                d.get("created_at", ""),
            ]

        if separate_sheets:
            # Group trips by car
            trips_by_car: dict[str, list] = {}
            for doc in docs:
                d = doc.to_dict()
                c_id = d.get("car_id", "")
                if c_id not in trips_by_car:
                    trips_by_car[c_id] = []
                trips_by_car[c_id].append(d)

            # Get existing sheet names
            spreadsheet = sheets.spreadsheets().get(spreadsheetId=spreadsheet_id).execute()
            existing_sheets = {s["properties"]["title"] for s in spreadsheet.get("sheets", [])}

            total_rows = 0
            sheets_created = []

            for c_id, trips in trips_by_car.items():
                car_name = car_names.get(c_id, c_id) if c_id else "Onbekend"
                sheet_name = car_name[:31]

                if sheet_name not in existing_sheets:
                    sheets.spreadsheets().batchUpdate(
                        spreadsheetId=spreadsheet_id,
                        body={"requests": [{"addSheet": {"properties": {"title": sheet_name}}}]},
                    ).execute()
                    sheets_created.append(sheet_name)

                rows = [headers]
                for d in trips:
                    rows.append(build_row(d))

                sheets.spreadsheets().values().update(
                    spreadsheetId=spreadsheet_id,
                    range=f"'{sheet_name}'!A1",
                    valueInputOption="USER_ENTERED",
                    body={"values": rows},
                ).execute()

                total_rows += len(rows) - 1

            return {
                "status": "exported",
                "rows": total_rows,
                "separate_sheets": True,
                "sheets_created": sheets_created,
                "cars": list(trips_by_car.keys()),
            }
        else:
            # Single sheet export
            rows = [headers]
            for doc in docs:
                d = doc.to_dict()
                rows.append(build_row(d))

            sheets.spreadsheets().values().update(
                spreadsheetId=spreadsheet_id,
                range="A1",
                valueInputOption="USER_ENTERED",
                body={"values": rows},
            ).execute()

            return {"status": "exported", "rows": len(rows) - 1}

    def compare_odometer(self, user_id: str, car_id: str | None = None) -> dict:
        """Compare car odometer with calculated trips."""
        db = get_db()

        # Get start_odometer for specific car or fallback to user settings
        start_odo = car_service.get_car_start_odometer(user_id, car_id)

        # Get user's odometer readings
        readings_docs = db.collection("users").document(user_id).collection("odometer_readings").order_by("created_at").stream()
        odometer_readings = []
        for doc in readings_docs:
            d = doc.to_dict()
            if d.get("odometer_km"):
                odometer_readings.append({
                    "timestamp": d.get("created_at") or d.get("fetched_at"),
                    "odometer_km": d["odometer_km"],
                })

        # Get user's trips sorted by actual trip date
        trips_query = db.collection("trips").where("user_id", "==", user_id)
        if car_id:
            trips_query = trips_query.where("car_id", "==", car_id)
        trips_docs = list(trips_query.stream())

        # Parse date and time to create proper datetime for sorting
        def parse_trip_datetime(d):
            try:
                date_str = d.get("date", "01-01-2025")
                time_str = d.get("start_time", "00:00")
                parts = date_str.split("-")
                if len(parts) == 3:
                    day, month, year = parts
                    return f"{year}-{month}-{day}T{time_str}:00"
            except:
                pass
            return d.get("created_at", "2025-01-01T00:00:00")

        # Sort by actual trip date
        trips_data = [(doc, doc.to_dict()) for doc in trips_docs]
        trips_data.sort(key=lambda x: parse_trip_datetime(x[1]))

        trips_timeline = []
        running_total = start_odo

        for doc, d in trips_data:
            distance = d.get("distance_km", 0)
            running_total += distance
            trips_timeline.append({
                "timestamp": parse_trip_datetime(d),
                "date": d.get("date"),
                "trip_id": d.get("id"),
                "distance_km": distance,
                "cumulative_km": round(running_total, 1),
                "from": d.get("from_address"),
                "to": d.get("to_address"),
            })

        # Calculate current comparison
        latest_reading = odometer_readings[-1] if odometer_readings else None
        calculated_total = running_total

        comparison = None
        warnings = []

        if latest_reading:
            actual = latest_reading["odometer_km"]
            diff = actual - calculated_total
            diff_percent = (diff / actual * 100) if actual > 0 else 0

            comparison = {
                "actual_odometer_km": actual,
                "calculated_km": round(calculated_total, 1),
                "difference_km": round(diff, 1),
                "difference_percent": round(diff_percent, 2),
                "status": "ok" if abs(diff_percent) <= 2 else "warning",
                "reading_timestamp": latest_reading["timestamp"],
            }

            if abs(diff_percent) > 2:
                warnings.append({
                    "type": "deviation",
                    "message": f"Afwijking {diff_percent:.1f}% ({diff:.1f} km) - meer dan 2% toegestaan",
                    "suggestion": "Controleer of alle ritten zijn gelogd" if diff > 0 else "Controleer afstanden van gelogde ritten",
                })

        return {
            "car_id": car_id,
            "start_odometer": start_odo,
            "trips_timeline": trips_timeline,
            "odometer_readings": odometer_readings,
            "comparison": comparison,
            "warnings": warnings,
        }


# Singleton instance
export_service = ExportService()
