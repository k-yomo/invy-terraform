terraform {
  backend "gcs" {
    bucket = "invy-dev-tf-state"
  }
}
