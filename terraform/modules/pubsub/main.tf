# Reference the existing Pub/Sub topic used for Transcoder completion events.
data "google_pubsub_topic" "completion_pubsub_topic" {
  name = var.completion_pubsub_topic_name
}
