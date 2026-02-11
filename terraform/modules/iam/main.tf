# Lookup the service account used by Eventarc triggers and workflows.
data "google_service_account" "eventarc_sa" {
  account_id = var.service_account_name
}

# Create a service identity for the Video Intelligence API.
resource "google_project_service_identity" "video_intelligence_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "videointelligence.googleapis.com"
}

# Grant the Video Intelligence service account permission to write to the metadata bucket.
resource "google_storage_bucket_iam_member" "video_intelligence_storage_admin" {
  bucket = var.video_metadata_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_project_service_identity.video_intelligence_sa.email}"
}
