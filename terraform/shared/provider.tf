# Provider requirements and version pinning for consistent deployments.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

# Configure the Google provider with environment-specific project and region.
provider "google" {
  project = var.project_id
  region  = var.project_region
}
