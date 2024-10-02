# resource "google_pubsub_topic" "kpi_topic" {
#   name    = "kpi-topic"
#   project = var.project_id
# }

# resource "google_pubsub_subscription" "kpi_subscription" {
#   name    = "kpi-subscription"
#   topic   = google_pubsub_topic.kpi_topic.name
#   project = var.project_id
# }