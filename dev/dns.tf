
resource "google_dns_managed_zone" "invy_app_dev" {
  name     = "invy-app-dev"
  dns_name = "invy-app.dev."

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "api_invy_app_dev" {
  name = "api.${google_dns_managed_zone.invy_app_dev.dns_name}"
  type = "CNAME"
  ttl  = 86400

  managed_zone = google_dns_managed_zone.invy_app_dev.name

  rrdatas = ["ghs.googlehosted.com."]

  lifecycle {
    prevent_destroy = false
  }
}
