variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west4"
}

variable "maps_api_key" {
  description = "Google Maps API Key"
  type        = string
  sensitive   = true
}

variable "home_lat" {
  description = "Home latitude"
  type        = string
}

variable "home_lon" {
  description = "Home longitude"
  type        = string
}

variable "office_lat" {
  description = "Office latitude"
  type        = string
}

variable "office_lon" {
  description = "Office longitude"
  type        = string
}

variable "start_odometer" {
  description = "Starting odometer reading"
  type        = string
  default     = "0"
}

variable "skip_lat" {
  description = "Skip location latitude (e.g., daycare - intermediate stop)"
  type        = string
  default     = "0.0"
}

variable "skip_lon" {
  description = "Skip location longitude"
  type        = string
  default     = "0.0"
}

variable "auth_enabled" {
  description = "Enable Identity Platform authentication"
  type        = string
  default     = "false"
}

# Google OAuth credentials are read from Secret Manager (see secrets.tf)
# - google-oauth-client-id
# - google-oauth-client-secret

variable "apple_client_id" {
  description = "Apple Services ID for Sign in with Apple"
  type        = string
  default     = ""
}

variable "apple_client_secret" {
  description = "Apple client secret (JWT) for Sign in with Apple"
  type        = string
  sensitive   = true
  default     = ""
}

variable "openchargemap_api_key" {
  description = "Open Charge Map API key for charging station data"
  type        = string
  sensitive   = true
  default     = ""
}
