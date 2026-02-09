# Pub/Sub topic that receives Transcoder API completion notifications.
variable "completion_pubsub_topic_name" {
  description = "The name of the Pub/Sub topic to be used for transcode completion events."
  type        = string
}
