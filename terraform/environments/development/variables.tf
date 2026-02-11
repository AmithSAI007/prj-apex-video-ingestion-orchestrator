# -----------------------------------------------------------------------------
# Development environment inputs.
# -----------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "The unique identifier for the GCP project for resource organization and billing."
  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id must not be empty."
  }
}

variable "project_region" {
  type        = string
  description = "The GCP region where the resources will be deployed, impacting latency and compliance."
  validation {
    condition     = length(var.project_region) > 0
    error_message = "The project_region must be specified."
  }
}

variable "service_account_name" {
  description = "The service account name to be used by the Cloud Run service."
  type        = string
  default     = "apex-video-orchestrator-svc"
}

variable "transcoder_template_id" {
  description = "The ID of the Transcoder template to be used for video processing."
  type        = string
}

variable "workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "prj-apex-video-orchestrator-workflow"
}

variable "completion_workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "prj-apex-video-transcode-completion-workflow"
}

variable "firestore_db_name" {
  description = "The name of the Firestore database to be used for storing video metadata."
  type        = string
  default     = "apex-firestore-db"
}

variable "completion_pubsub_topic_name" {
  description = "The name of the Pub/Sub topic to be used for transcode completion events."
  type        = string
  default     = "apex-transcoder-status-topic"
}

variable "video_metadata_bucket_name" {
  description = "The name of the bucket where video metadata is stored."
  type        = string
  default     = "apex-dev-gcs-video-metadata"
}
