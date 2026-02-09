# Remote state configuration for shared, team-friendly Terraform state storage.
terraform {
  backend "gcs" {
    bucket = "prj-apex-infra-terraform-state"
    prefix = "terraform/apex-video-ingestion-orchestrator/state"
  }
}
