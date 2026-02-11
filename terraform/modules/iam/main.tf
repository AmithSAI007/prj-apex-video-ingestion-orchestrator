# Lookup the service account used by Eventarc triggers and workflows.
data "google_service_account" "eventarc_sa" {
  account_id = var.service_account_name
}

# Lookup project number to construct the service agent email.
data "google_project" "project" {
  project_id = var.project_id
}

# Grant the Video Intelligence service account permission to write to the metadata bucket.
# The service agent is automatically created when the API is enabled.
# Format: service-[PROJECT_NUMBER]@gcp-sa-videointelligence.iam.gserviceaccount.com
resource "google_storage_bucket_iam_member" "video_intelligence_storage_admin" {
  bucket = var.video_metadata_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-videointelligence.iam.gserviceaccount.com"
}
