
resource "google_project_iam_binding" "project_owners" {
  project = local.project
  members = [
    "serviceAccount:${google_service_account.terraform_ci.email}",
    "user:kanji.yy@gmail.com"
  ]
  role = "roles/owner"
}

resource "google_project_iam_binding" "cloudsql_client" {
  project = local.project
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.invy_api.email}",
    # For external datasource connection
    "serviceAccount:service-${local.project_number}@gcp-sa-bigqueryconnection.iam.gserviceaccount.com"
  ]
}
