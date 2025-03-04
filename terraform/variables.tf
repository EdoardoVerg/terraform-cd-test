variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  default     = "europe-west3"
  type        = string
}

variable "service_name" {
  description = "Cloud Run service name"
  default     = "my-cloud-run-service"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for Cloud Run"
  type        = string
}