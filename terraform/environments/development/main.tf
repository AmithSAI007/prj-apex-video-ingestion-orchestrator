module "iam" {
  source               = "../../modules/iam"
  service_account_name = var.service_account_name
}

module "storage" {
  source = "../../modules/storage"
}

module "eventarc_trigger" {
  source                 = "../../modules/triggers"
  project_id             = var.project_id
  project_region         = var.project_region
  raw_videos_bucket_name = module.storage.raw_videos_bucket_name
  service_account_name   = module.iam.service_account_name
}
