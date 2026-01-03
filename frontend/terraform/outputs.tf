output "frontend_url" {
  value = google_cloud_run_v2_service.frontend.uri
}

output "custom_domain" {
  value = var.domain
}

output "dns_records" {
  value = google_cloud_run_domain_mapping.frontend.status[0].resource_records
}

output "domain_setup_instructions" {
  value = <<-EOT
    Add DNS record at your provider:
    CNAME  mileage  ghs.googlehosted.com
  EOT
}
