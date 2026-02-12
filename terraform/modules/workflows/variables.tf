# Project identifier used for workflow resource names.
variable "project_id" {
  type        = string
  description = "The unique identifier for the GCP project for resource organization and billing."
  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id must not be empty."
  }
}

# Region where workflows run.
variable "project_region" {
  type        = string
  description = "The GCP region where the resources will be deployed, impacting latency and compliance."
  validation {
    condition     = length(var.project_region) > 0
    error_message = "The project_region must be specified."
  }
}

# Service account that executes workflow steps.
variable "service_account_name" {
  description = "The service account name to be used by the Cloud Run service."
  type        = string
}

variable "execution_history_level" {
  description = "The level of execution history to retain for the workflow."
  type        = string
  default     = "EXECUTION_HISTORY_DETAILED"
}

variable "workflows" {
  description = "A map of workflows to deploy. Key is the identifier, value contains name, source content, and env vars."
  type = map(object({
    name            = string
    description     = optional(string)
    source_contents = string
    env_vars        = map(string)
  }))
}
