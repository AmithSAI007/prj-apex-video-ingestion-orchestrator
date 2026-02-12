# -----------------------------------------------------------------------------
# Development environment composition for the Apex video ingestion orchestrator.
# This file wires together shared modules to assemble the full deployment.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Locals: Workflow Configuration
# Centralizes the construction of workflow definitions and environment variables.
# This separates configuration logic from the module instantiation below.
# -----------------------------------------------------------------------------
locals {
  workflows_config = {
    ingestion = {
      name            = var.workflow_name
      description     = "Primary workflow that handles ingestion, logging, and job kick-off."
      source_contents = file("${path.module}/../../../workflows/ingestion-main.yaml")
      env_vars = {
        PROJECT_ID             = var.project_id
        PROJECT_REGION         = var.project_region
        TRANSCODER_TEMPLATE_ID = var.transcoder_template_id
        PROCESSED_BUCKET       = module.storage.processed_videos_bucket_name
        FIRESTORE_DB           = var.firestore_db_name
        SERVICE_ACCOUNT_EMAIL  = module.iam.service_account_name
      }
    }
    completion = {
      name            = var.completion_workflow_name
      description     = "Secondary workflow that handles Transcoder completion callbacks."
      source_contents = file("${path.module}/../../../workflows/completion-main.yaml")
      env_vars = {
        FIRESTORE_DB = var.firestore_db_name
      }
    }
    worker = {
      name            = var.worker_workflow_name
      description     = "Worker workflow triggered by Cloud Tasks to echo input payloads."
      source_contents = file("${path.module}/../../../workflows/video-processing-worker.yaml")
      env_vars        = {}
    }
  }
}


# Resolve the service account that Eventarc and Workflows run as.
module "iam" {
  source               = "../../modules/iam"
  service_account_name = var.service_account_name
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
  source               = "../../modules/workflows"
  project_id           = var.project_id
  project_region       = var.project_region
  service_account_name = module.iam.service_account_name
  workflows            = local.workflows_config
}

module "tasks" {
  source                = "../../modules/tasks"
  project_region        = var.project_region
  transcoder_queue_name = var.transcoder_queue_name
}
