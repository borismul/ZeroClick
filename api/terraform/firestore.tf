# Firestore Database

resource "google_firestore_database" "main" {
  name                        = "(default)"
  location_id                 = "eur3"
  type                        = "FIRESTORE_NATIVE"
  deletion_policy             = "DELETE"
  delete_protection_state     = "DELETE_PROTECTION_DISABLED"

  depends_on = [google_project_service.apis]
}

# Composite index for trips sorted by sort_date and start_time (per user)
resource "google_firestore_index" "trips_by_user_and_sort_date" {
  database   = google_firestore_database.main.name
  collection = "trips"

  fields {
    field_path = "user_id"
    order      = "ASCENDING"
  }

  fields {
    field_path = "sort_date"
    order      = "DESCENDING"
  }

  fields {
    field_path = "start_time"
    order      = "DESCENDING"
  }
}

# Composite index for trips sorted by created_at (for trip creation validation)
resource "google_firestore_index" "trips_by_user_and_created_at" {
  database   = google_firestore_database.main.name
  collection = "trips"

  fields {
    field_path = "user_id"
    order      = "ASCENDING"
  }

  fields {
    field_path = "created_at"
    order      = "DESCENDING"
  }
}

# Composite index for trips filtered by car_id
resource "google_firestore_index" "trips_by_car_user_and_sort_date" {
  database   = google_firestore_database.main.name
  collection = "trips"

  fields {
    field_path = "car_id"
    order      = "ASCENDING"
  }

  fields {
    field_path = "user_id"
    order      = "ASCENDING"
  }

  fields {
    field_path = "sort_date"
    order      = "DESCENDING"
  }

  fields {
    field_path = "start_time"
    order      = "DESCENDING"
  }
}
