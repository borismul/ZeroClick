resource "google_service_account" "frontend" {
  account_id   = "mileage-frontend-sa"
  display_name = "Mileage Tracker Frontend"
}
