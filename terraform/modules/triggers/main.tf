resource "google_eventarc_trigger" "storage_trigger" {
  name     = var.trigger_name
  location = var.project_region
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  matching_criteria {
    attribute = "bucket"
    value     = var.raw_videos_bucket_name
  }

  destination {
    workflow = "projects/${var.project_id}/locations/${var.project_region}/workflows/${var.workflow_name}"
  }

  retry_policy {
    max_attempts = 1
  }

  service_account = var.service_account_name
}
