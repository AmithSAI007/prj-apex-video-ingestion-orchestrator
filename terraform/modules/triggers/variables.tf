# Core project identity used for Eventarc workflow destinations.
variable "project_id" {
  type        = string
  description = "The unique identifier for the GCP project for resource organization and billing."
  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id must not be empty."
  }
}

# Region where Eventarc and Workflows are hosted.
variable "project_region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
  validation {
    condition     = length(var.project_region) > 0
    error_message = "The project_region must be specified."
  }
}

# Name for the ingestion trigger tied to storage finalize events.
variable "trigger_name" {
  description = "The name of the Eventarc trigger."
  type        = string
  default     = "apex-transcoder-workflow-trigger"
}

# Raw uploads bucket that emits Cloud Storage events.
variable "raw_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket to monitor for new video uploads."
  type        = string
}

# Service account granted permission to invoke workflows.
variable "service_account_name" {
  description = "The name of the service account used by the Eventarc trigger."
  type        = string
}

# Target ingestion workflow to invoke on storage events.
variable "workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "prj-apex-storage-ingestion-workflow"
}

# Name for the trigger that listens for Transcoder completion Pub/Sub events.
variable "completion_trigger_name" {
  description = "The name of the Eventarc trigger."
  type        = string
  default     = "apex-transcoder-completion-workflow-trigger"
}

# Target completion workflow to invoke on Pub/Sub notifications.
variable "completion_workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "prj-apex-transcoder-completion-workflow"
}

# Pub/Sub topic ID used by Transcoder to emit completion messages.
variable "transcoder_complete_topic_id" {
  description = "The ID of the Pub/Sub topic to which the Transcoder API will publish completion messages."
  type        = string

}
