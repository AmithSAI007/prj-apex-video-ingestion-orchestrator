# -----------------------------------------------------------------------------
# Development environment composition for the Apex video ingestion orchestrator.
# This file wires together shared modules to assemble the full deployment.
# -----------------------------------------------------------------------------

# Resolve the service account that Eventarc and Workflows run as.
module "iam" {
  source                     = "../../modules/iam"
  service_account_name       = var.service_account_name
  project_id                 = var.project_id
  video_metadata_bucket_name = var.video_metadata_bucket_name
}

# Reference existing storage buckets for raw and processed media.
module "storage" {
  source = "../../modules/storage"
}

# Reference the Pub/Sub topic used for Transcoder completion events.
module "pubsub" {
  source                       = "../../modules/pubsub"
  completion_pubsub_topic_name = var.completion_pubsub_topic_name
}

# Eventarc triggers for ingestion and completion workflow execution.
module "eventarc_trigger" {
  source                       = "../../modules/triggers"
  project_id                   = var.project_id
  project_region               = var.project_region
  raw_videos_bucket_name       = module.storage.raw_videos_bucket_name
  service_account_name         = module.iam.service_account_name
  transcoder_complete_topic_id = module.pubsub.completion_pubsub_topic_id
}

# Cloud Workflows definitions that orchestrate ingest and completion handling.
module "workflows" {
  source                   = "../../modules/workflows"
  project_id               = var.project_id
  project_region           = var.project_region
  workflow_name            = var.workflow_name
  completion_workflow_name = var.completion_workflow_name
  service_account_name     = module.iam.service_account_name
  transcoder_template_id   = var.transcoder_template_id
  processed_bucket_name    = module.storage.processed_videos_bucket_name
  firestore_db_name        = var.firestore_db_name

}
