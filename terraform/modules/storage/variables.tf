# Bucket that emits Cloud Storage finalize events for ingestion.
variable "raw_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket to monitor for new video uploads."
  type        = string
  default     = "apex-dev-gcs-raw-videos"
}

# Bucket where the Transcoder service writes outputs.
variable "processed_videos_bucket_name" {
  description = "The name of the Cloud Storage bucket where processed videos will be stored."
  type        = string
  default     = "apex-dev-gcs-processed-videos"
}
