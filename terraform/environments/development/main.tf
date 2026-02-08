module "iam" {
  source               = "../../modules/iam"
  service_account_name = var.service_account_name
}

module "storage" {
  source = "../../modules/storage"
}

module "eventarc_trigger" {
  source                       = "../../modules/triggers"
  project_id                   = var.project_id
  project_region               = var.project_region
  raw_videos_bucket_name       = module.storage.raw_videos_bucket_name
  service_account_name         = module.iam.service_account_name
  completion_pubsub_topic_name = var.completion_pubsub_topic_name
}

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
