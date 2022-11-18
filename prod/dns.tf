
resource "google_dns_managed_zone" "invy_app_com" {
  name     = "invy-app-com"
  dns_name = "invy-app.com."

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "api_invy_app_com" {
  name = "api.${google_dns_managed_zone.invy_app_com.dns_name}"
  type = "CNAME"
  ttl  = 86400

  managed_zone = google_dns_managed_zone.invy_app_com.name

  rrdatas = ["ghs.googlehosted.com."]

  lifecycle {
    prevent_destroy = false
  }
}
