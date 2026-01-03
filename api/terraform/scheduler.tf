# Cloud Scheduler safety net - recovers stale/orphaned trips
# Runs every 30 min, always enabled

resource "google_project_service" "cloudscheduler" {
  project = var.project_id
  service = "cloudscheduler.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_cloud_scheduler_job" "odometer_poll" {
  name        = "odometer-poll"
  description = "Safety net: recover stale trips every 30 min"
  schedule    = "*/30 * * * *" # Every 30 minutes
  time_zone   = "Europe/Amsterdam"
  project     = var.project_id
  region      = "europe-west1" # Cloud Scheduler requires specific regions
  paused      = false          # Always enabled

  http_target {
    http_method = "GET"
    uri         = "${google_cloud_run_v2_service.api.uri}/audi/check-trip"
  }

  retry_config {
    retry_count          = 1
    min_backoff_duration = "10s"
    max_backoff_duration = "60s"
  }

  depends_on = [
    google_project_service.cloudscheduler,
    google_cloud_run_v2_service.api,
  ]
}

output "scheduler_name" {
  value = google_cloud_scheduler_job.odometer_poll.name
}
