terraform {
  backend "gcs" {
    bucket = "invy-prod-tf-state"
  }
}
