
resource "google_artifact_registry_repository" "invy" {
  provider      = google-beta
  location      = local.default_region
  repository_id = "invy"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "invy_viewers" {
  provider   = google-beta
  location   = google_artifact_registry_repository.invy.location
  repository = google_artifact_registry_repository.invy.name
  role       = "roles/viewer"
  members = [
    # Cloud RuN service agent
    "serviceAccount:service-${local.project_number}@serverless-robot-prod.iam.gserviceaccount.com",
  ]
}

resource "google_artifact_registry_repository_iam_binding" "editors" {
  provider   = google-beta
  location   = google_artifact_registry_repository.invy.location
  repository = google_artifact_registry_repository.invy.name
  role       = "roles/editor"
  members = [
    "serviceAccount:${google_service_account.api_ci.email}",
  ]
}
