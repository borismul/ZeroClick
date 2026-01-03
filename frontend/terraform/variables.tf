variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west4"
}

variable "api_url" {
  description = "API URL for frontend"
  type        = string
}

variable "domain" {
  description = "Custom domain for frontend"
  type        = string
  default     = "mileage.borism.nl"
}

variable "nextauth_secret" {
  description = "Secret for NextAuth.js session encryption"
  type        = string
  sensitive   = true
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  sensitive   = true
}
