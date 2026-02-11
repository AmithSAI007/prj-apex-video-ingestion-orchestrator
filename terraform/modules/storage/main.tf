# Reference the existing bucket that receives raw video uploads.
data "google_storage_bucket" "apex_dev_gcs_raw_videos" {
  name = var.raw_videos_bucket_name
}

# Reference the existing bucket that stores processed/transcoded assets.
data "google_storage_bucket" "apex_dev_gcs_processed_videos" {
  name = var.processed_videos_bucket_name
}
