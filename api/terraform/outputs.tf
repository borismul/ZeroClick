output "api_url" {
  description = "API URL (use in iPhone Shortcuts)"
  value       = google_cloud_run_v2_service.api.uri
}

output "service_account_email" {
  value = google_service_account.api.email
}
