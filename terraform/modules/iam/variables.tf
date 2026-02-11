# Service account identifier that owns Eventarc/Workflow execution permissions.
variable "service_account_name" {
  description = "The name of the Cloud Storage bucket to monitor for new video uploads."
  type        = string
  default     = "prj-apex-cr-start-transcode-sa"
}
