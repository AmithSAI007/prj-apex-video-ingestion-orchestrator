variable "project_id" {
  type        = string
  description = "The unique identifier for the GCP project for resource organization and billing."
  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id must not be empty."
  }
}

variable "project_region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
  validation {
    condition     = length(var.project_region) > 0
    error_message = "The project_region must be specified."
  }
}

variable "trigger_name" {
  description = "The name of the Eventarc trigger."
  type        = string
  default     = "apex-transcoder-workflow-trigger"
}

variable "raw_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket to monitor for new video uploads."
  type        = string
}

variable "service_account_name" {
  description = "The name of the service account used by the Eventarc trigger."
  type        = string
}

variable "workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "prj-apex-video-orchestrator"
}

variable "completion_trigger_name" {
  description = "The name of the Eventarc trigger."
  type        = string
  default     = "apex-transcoder-completion-workflow-trigger"
}

variable "completion_workflow_name" {
  description = "The name of the Workflow to be triggered by Eventarc."
  type        = string
  default     = "apex-transcoder-status-topic"
}

variable "transcoder_complete_topic_id" {
  description = "The ID of the Pub/Sub topic to which the Transcoder API will publish completion messages."
  type        = string
}
