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
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "public" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name

  policy_data = jsonencode({
    bindings = [
      {
        role = "roles/run.invoker"
        members = ["allUsers"]
      }
    ]
  })
}