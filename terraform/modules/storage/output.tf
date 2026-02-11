# Expose raw uploads bucket name to Eventarc and workflow modules.
output "raw_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket to monitor for new video uploads."
  value       = data.google_storage_bucket.apex_dev_gcs_raw_videos.name
}

# Expose processed bucket name for workflow environment variables.
output "processed_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket where processed videos will be stored."
  value       = data.google_storage_bucket.apex_dev_gcs_processed_videos.name
}
