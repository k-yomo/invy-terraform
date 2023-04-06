
resource "google_bigquery_connection" "invy_db" {
    friendly_name = "Invy DB"
    description   = "Main Database usd in Invy"
    location      = "asia-northeast1"
    cloud_sql {
        instance_id = google_sql_database_instance.invy.connection_name
        database    = google_sql_database.invy.name
        type        = "POSTGRES"
        credential {
          username = google_sql_user.postgres.name
          password = google_sql_user.postgres.password
        }
    }
}

resource "google_project_iam_member" "bigquery_is_cloudsql_client" {
    project = local.project
    member  = "serviceAccount:service-${local.project_number}@gcp-sa-bigqueryconnection.iam.gserviceaccount.com"
    role    = "roles/cloudsql.client"
}

