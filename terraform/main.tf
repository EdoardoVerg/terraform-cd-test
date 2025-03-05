terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

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
  default     = "github-actions-deployer@soft-analytics-gcp.iam.gserviceaccount.com"
  description = "Service account email for Cloud Run"
  type        = string
}


resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = var.service_account_email
      containers {
        image = "gcr.io/${var.project_id}/${var.service_name}"
      }
    }
  }

  traffic {
    latest_revision = true
    percent         = 100
  }

  # Force recreation of the service
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run.id
    ]
  }
}

# Force recreation trigger
resource "null_resource" "always_run" {
  triggers = {
    timestamp = timestamp()
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.service_account_email}"
}


output "service_url" {
  value = google_cloud_run_service.default.status[0].url
}