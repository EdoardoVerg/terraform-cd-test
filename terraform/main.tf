resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  # Add this lifecycle block
  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations,
      metadata[0].annotations
    ]
  }

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
}