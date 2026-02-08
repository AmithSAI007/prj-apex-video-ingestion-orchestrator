resource "google_workflows_workflow" "video_orchestrator" {
  name            = var.workflow_name
  region          = var.project_region
  service_account = var.service_account_name

  source_contents = file("${path.module}/../workflows/ingestion-main.yaml")

  user_env_vars = {
    PROJECT_ID             = var.project_id
    PROJECT_REGION         = var.project_region
    TRANSCODER_TEMPLATE_ID = var.transcoder_template_id
    PROCESSED_BUCKET       = var.processed_bucket_name
    FIRESTORE_DB           = var.firestore_db_name
  }
}

# resource "google_workflows_workflow" "transcode_completion_workflow" {
#   name            = var.completion_workflow_name
#   region          = var.project_region
#   service_account = var.service_account_name
#
#   source_contents = file("${path.module}/../workflows/completion-main.yaml")
#   user_env_vars = {
#     FIRESTORE_DB = var.firestore_db_name
#   }
# }
