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

  service_account = var.service_account_name
}


# resource "google_eventarc_trigger" "trancode_completion_trigger" {
#   name     = var.completion_trigger_name
#   location = var.project_region
#   transport {
#     pubsub {
#       topic = "projects/${var.project_id}/topics/transcode-completion-topic"
#     }
#   }
#
#   matching_criteria {
#     attribute = "type"
#     value     = "google.cloud.pubsub.topic.v1.messagePublished"
#   }
#
#
#   destination {
#     workflow = "projects/${var.project_id}/locations/${var.project_region}/workflows/${var.completion_workflow_name}"
#   }
#
#   service_account = var.service_account_name
# }
