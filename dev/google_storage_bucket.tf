resource "google_storage_bucket" "avatar_images" {
  name     = "invy-${local.env}-avatar-images"
  location = "asia"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "invy_api_is_avatar_image_object_creator" {
  bucket = google_storage_bucket.avatar_images.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.invy_api.email}"
}

resource "google_storage_bucket_iam_member" "all_users_are_avatar_image_object_viewer" {
  bucket = google_storage_bucket.avatar_images.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
