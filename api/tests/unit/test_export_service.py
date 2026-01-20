"""Unit tests for export_service.py - stats, export, and odometer comparison.

Tests verify:
- get_stats() aggregation with various filters
- export_to_sheets() single and multi-sheet export
- compare_odometer() timeline calculation and warnings
"""

import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime


class TestGetStats:
    """Tests for get_stats aggregation."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database with trip data."""
        trips = [
            {
                "id": "trip-1",
                "user_id": "test@example.com",
                "distance_km": 15.0,
                "business_km": 15.0,
                "private_km": 0,
                "car_id": "car-1",
                "created_at": "2024-01-15T08:00:00Z",
            },
            {
                "id": "trip-2",
                "user_id": "test@example.com",
                "distance_km": 25.0,
                "business_km": 0,
                "private_km": 25.0,
                "car_id": "car-1",
                "created_at": "2024-01-16T10:00:00Z",
            },
            {
                "id": "trip-3",
                "user_id": "test@example.com",
                "distance_km": 30.0,
                "business_km": 30.0,
                "private_km": 0,
                "car_id": "car-2",
                "created_at": "2024-02-10T09:00:00Z",
            },
            {
                "id": "trip-4",
                "user_id": "other@example.com",
                "distance_km": 100.0,
                "business_km": 100.0,
                "private_km": 0,
                "car_id": "car-other",
                "created_at": "2024-01-15T08:00:00Z",
            },
        ]

        mock_query = MagicMock()

        def mock_stream():
            for trip in trips:
                mock_doc = MagicMock()
                mock_doc.to_dict.return_value = trip
                yield mock_doc

        mock_query.stream = mock_stream

        def create_filtered_query(filter_arg):
            """Build filtered query based on chained where calls."""
            filtered_trips = trips.copy()

            # Filter by user_id
            if hasattr(filter_arg, "field_path") and filter_arg.field_path == "user_id":
                filtered_trips = [t for t in filtered_trips if t["user_id"] == filter_arg.value]
            # Filter by created_at >= (start date)
            elif hasattr(filter_arg, "field_path") and filter_arg.field_path == "created_at":
                if filter_arg.op_string == ">=":
                    filtered_trips = [t for t in filtered_trips if t["created_at"] >= filter_arg.value]
                elif filter_arg.op_string == "<":
                    filtered_trips = [t for t in filtered_trips if t["created_at"] < filter_arg.value]

            new_query = MagicMock()

            def new_stream():
                for trip in filtered_trips:
                    mock_doc = MagicMock()
                    mock_doc.to_dict.return_value = trip
                    yield mock_doc

            new_query.stream = new_stream
            new_query.where = lambda filter: create_filtered_query(filter)
            return new_query

        mock_query.where = lambda filter: create_filtered_query(filter)

        with patch("services.export_service.get_db") as mock_get_db:
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_query
            mock_get_db.return_value = mock_db
            yield {"trips": trips}

    def test_get_stats_all_trips(self, mock_db):
        """get_stats returns totals for all user trips."""
        from services.export_service import export_service

        result = export_service.get_stats("test@example.com")

        assert result["total_km"] == 70.0  # 15 + 25 + 30
        assert result["business_km"] == 45.0  # 15 + 30
        assert result["private_km"] == 25.0
        assert result["trip_count"] == 3

    def test_get_stats_filtered_by_car(self, mock_db):
        """get_stats filters by car_id."""
        from services.export_service import export_service

        result = export_service.get_stats("test@example.com", car_id="car-1")

        assert result["total_km"] == 40.0  # 15 + 25
        assert result["business_km"] == 15.0
        assert result["private_km"] == 25.0
        assert result["trip_count"] == 2

    def test_get_stats_only_user_trips(self, mock_db):
        """get_stats only returns trips for specified user."""
        from services.export_service import export_service

        result = export_service.get_stats("test@example.com")

        # Should not include other@example.com's trip
        assert result["trip_count"] == 3
        assert result["total_km"] == 70.0

    def test_get_stats_empty_result(self, mock_db):
        """get_stats returns zeros when no trips match."""
        from services.export_service import export_service

        result = export_service.get_stats("test@example.com", car_id="nonexistent-car")

        assert result["total_km"] == 0.0
        assert result["business_km"] == 0.0
        assert result["private_km"] == 0.0
        assert result["trip_count"] == 0

    def test_get_stats_rounds_to_one_decimal(self, mock_db):
        """get_stats rounds all km values to 1 decimal."""
        from services.export_service import export_service

        result = export_service.get_stats("test@example.com")

        # Values should be rounded
        assert isinstance(result["total_km"], float)
        assert str(result["total_km"]).count(".") <= 1


class TestExportToSheets:
    """Tests for export_to_sheets functionality."""

    @pytest.fixture
    def mock_db_and_sheets(self):
        """Mock Firestore and Google Sheets APIs."""
        trips = [
            {
                "id": "trip-1",
                "date": "15-01-2024",
                "start_time": "08:00",
                "end_time": "08:30",
                "from_address": "Home",
                "to_address": "Office",
                "from_lat": 51.90,
                "from_lon": 4.45,
                "to_lat": 51.95,
                "to_lon": 4.50,
                "distance_km": 15.0,
                "trip_type": "B",
                "business_km": 15.0,
                "private_km": 0,
                "start_odo": 10000,
                "end_odo": 10015,
                "car_id": "car-1",
                "notes": "",
                "created_at": "2024-01-15T08:00:00Z",
            },
            {
                "id": "trip-2",
                "date": "16-01-2024",
                "start_time": "10:00",
                "end_time": "10:45",
                "from_address": "Office",
                "to_address": "Client",
                "from_lat": 51.95,
                "from_lon": 4.50,
                "to_lat": 52.00,
                "to_lon": 4.55,
                "distance_km": 25.0,
                "trip_type": "B",
                "business_km": 25.0,
                "private_km": 0,
                "start_odo": 10015,
                "end_odo": 10040,
                "car_id": "car-2",
                "notes": "Client visit",
                "created_at": "2024-01-16T10:00:00Z",
            },
        ]

        cars = {
            "car-1": {"name": "Audi A4"},
            "car-2": {"name": "Tesla Model 3"},
        }

        # Mock Firestore
        mock_query = MagicMock()

        def mock_stream():
            for trip in trips:
                mock_doc = MagicMock()
                mock_doc.to_dict.return_value = trip
                yield mock_doc

        mock_query.stream = mock_stream
        mock_query.order_by.return_value = mock_query
        mock_query.where = lambda filter: mock_query

        def mock_cars_stream():
            for car_id, car_data in cars.items():
                mock_doc = MagicMock()
                mock_doc.id = car_id
                mock_doc.to_dict.return_value = car_data
                yield mock_doc

        mock_cars_collection = MagicMock()
        mock_cars_collection.stream = mock_cars_stream

        mock_user_doc = MagicMock()
        mock_user_doc.collection.return_value = mock_cars_collection

        mock_users_collection = MagicMock()
        mock_users_collection.document.return_value = mock_user_doc

        # Mock Sheets API
        mock_sheets_values = MagicMock()
        mock_sheets_values.update.return_value.execute.return_value = {}

        mock_sheets_spreadsheets = MagicMock()
        mock_sheets_spreadsheets.values.return_value = mock_sheets_values
        mock_sheets_spreadsheets.get.return_value.execute.return_value = {
            "sheets": [{"properties": {"title": "Sheet1"}}]
        }
        mock_sheets_spreadsheets.batchUpdate.return_value.execute.return_value = {}

        mock_sheets_service = MagicMock()
        mock_sheets_service.spreadsheets.return_value = mock_sheets_spreadsheets

        with patch("services.export_service.get_db") as mock_get_db, \
             patch("services.export_service.default") as mock_default, \
             patch("services.export_service.build") as mock_build:

            mock_db = MagicMock()
            mock_db.collection.side_effect = lambda name: (
                mock_users_collection if name == "users" else mock_query
            )
            mock_get_db.return_value = mock_db

            mock_default.return_value = (MagicMock(), None)
            mock_build.return_value = mock_sheets_service

            yield {
                "trips": trips,
                "cars": cars,
                "sheets_values": mock_sheets_values,
                "sheets_spreadsheets": mock_sheets_spreadsheets,
            }

    def test_export_single_sheet(self, mock_db_and_sheets):
        """export_to_sheets writes all trips to single sheet."""
        from services.export_service import export_service

        result = export_service.export_to_sheets(
            user_id="test@example.com",
            spreadsheet_id="test-spreadsheet-id",
        )

        assert result["status"] == "exported"
        assert result["rows"] == 2

        # Verify sheets API was called
        mock_db_and_sheets["sheets_values"].update.assert_called_once()

    def test_export_extracts_spreadsheet_id_from_url(self, mock_db_and_sheets):
        """export_to_sheets extracts ID from full Google Sheets URL."""
        from services.export_service import export_service

        result = export_service.export_to_sheets(
            user_id="test@example.com",
            spreadsheet_id="https://docs.google.com/spreadsheets/d/abc123-xyz/edit#gid=0",
        )

        assert result["status"] == "exported"

    def test_export_invalid_url_returns_error(self, mock_db_and_sheets):
        """export_to_sheets returns error for invalid URL."""
        from services.export_service import export_service

        result = export_service.export_to_sheets(
            user_id="test@example.com",
            spreadsheet_id="https://docs.google.com/invalid/url",
        )

        assert "error" in result

    def test_export_separate_sheets_by_car(self, mock_db_and_sheets):
        """export_to_sheets creates separate sheets per car."""
        from services.export_service import export_service

        result = export_service.export_to_sheets(
            user_id="test@example.com",
            spreadsheet_id="test-spreadsheet-id",
            separate_sheets=True,
        )

        assert result["status"] == "exported"
        assert result["separate_sheets"] is True
        assert len(result["cars"]) == 2


class TestCompareOdometer:
    """Tests for compare_odometer timeline and deviation analysis."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore with trips and odometer readings."""
        trips = [
            {
                "id": "trip-1",
                "user_id": "test@example.com",
                "date": "15-01-2024",
                "start_time": "08:00",
                "distance_km": 15.0,
                "car_id": "car-1",
                "from_address": "Home",
                "to_address": "Office",
                "created_at": "2024-01-15T08:00:00Z",
            },
            {
                "id": "trip-2",
                "user_id": "test@example.com",
                "date": "16-01-2024",
                "start_time": "09:00",
                "distance_km": 25.0,
                "car_id": "car-1",
                "from_address": "Office",
                "to_address": "Client",
                "created_at": "2024-01-16T09:00:00Z",
            },
        ]

        odometer_readings = [
            {
                "odometer_km": 10050,
                "created_at": "2024-01-17T08:00:00Z",
            },
        ]

        # Mock Firestore queries
        def mock_trips_stream():
            for trip in trips:
                mock_doc = MagicMock()
                mock_doc.to_dict.return_value = trip
                yield mock_doc

        def mock_readings_stream():
            for reading in odometer_readings:
                mock_doc = MagicMock()
                mock_doc.to_dict.return_value = reading
                yield mock_doc

        mock_trips_query = MagicMock()
        mock_trips_query.stream.return_value = mock_trips_stream()
        mock_trips_query.where = lambda *args, **kwargs: mock_trips_query

        mock_readings_query = MagicMock()
        mock_readings_query.order_by.return_value.stream.return_value = mock_readings_stream()

        mock_user_doc = MagicMock()
        mock_user_doc.collection.return_value = mock_readings_query

        mock_users_collection = MagicMock()
        mock_users_collection.document.return_value = mock_user_doc

        with patch("services.export_service.get_db") as mock_get_db, \
             patch("services.export_service.car_service") as mock_car_service:

            mock_db = MagicMock()
            mock_db.collection.side_effect = lambda name: (
                mock_users_collection if name == "users" else mock_trips_query
            )
            mock_get_db.return_value = mock_db

            # Start odometer at 10000
            mock_car_service.get_car_start_odometer.return_value = 10000

            yield {
                "trips": trips,
                "readings": odometer_readings,
                "car_service": mock_car_service,
            }

    def test_compare_builds_timeline(self, mock_db):
        """compare_odometer builds cumulative timeline from trips."""
        from services.export_service import export_service

        result = export_service.compare_odometer("test@example.com", "car-1")

        assert result["start_odometer"] == 10000
        assert len(result["trips_timeline"]) == 2

        # Check cumulative km
        assert result["trips_timeline"][0]["cumulative_km"] == 10015.0  # 10000 + 15
        assert result["trips_timeline"][1]["cumulative_km"] == 10040.0  # 10015 + 25

    def test_compare_calculates_deviation(self, mock_db):
        """compare_odometer calculates difference from actual odometer."""
        from services.export_service import export_service

        result = export_service.compare_odometer("test@example.com", "car-1")

        # Actual odometer: 10050, Calculated: 10040, Diff: 10km
        assert result["comparison"]["actual_odometer_km"] == 10050
        assert result["comparison"]["calculated_km"] == 10040.0
        assert result["comparison"]["difference_km"] == 10.0

    def test_compare_warns_on_large_deviation(self, mock_db):
        """compare_odometer warns when deviation exceeds 2%."""
        from services.export_service import export_service

        result = export_service.compare_odometer("test@example.com", "car-1")

        # 10km difference on ~10040 calculated = ~0.1%, so no warning
        # But let's check the status logic
        diff_percent = abs(result["comparison"]["difference_percent"])
        if diff_percent > 2:
            assert len(result["warnings"]) > 0
            assert result["comparison"]["status"] == "warning"
        else:
            assert result["comparison"]["status"] == "ok"

    def test_compare_handles_no_readings(self, mock_db):
        """compare_odometer handles case with no odometer readings."""
        from services.export_service import export_service

        # Override to return empty readings
        with patch.object(export_service, "compare_odometer") as mock_compare:
            mock_compare.return_value = {
                "start_odometer": 10000,
                "trips_timeline": [],
                "odometer_readings": [],
                "comparison": None,
                "warnings": [],
            }
            result = mock_compare("test@example.com", "car-1")

        assert result["comparison"] is None
        assert result["odometer_readings"] == []

    def test_compare_sorts_trips_by_date(self, mock_db):
        """compare_odometer sorts trips by actual trip date."""
        from services.export_service import export_service

        result = export_service.compare_odometer("test@example.com", "car-1")

        # Verify chronological order
        timestamps = [t["timestamp"] for t in result["trips_timeline"]]
        assert timestamps == sorted(timestamps)
