# Lookup the service account used by Eventarc triggers and workflows.
data "google_service_account" "eventarc_sa" {
  account_id = var.service_account_name
}
