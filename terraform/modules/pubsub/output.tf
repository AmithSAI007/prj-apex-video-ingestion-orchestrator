# Export topic ID for Eventarc Pub/Sub trigger configuration.
output "completion_pubsub_topic_id" {
  value = data.google_pubsub_topic.completion_pubsub_topic.id
}
