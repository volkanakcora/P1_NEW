# resource "google_storage_bucket" "kpi_bucket" {
#   name          = "kpi-bucket"
#   location      = var.region
#   force_destroy = true
#   project = var.project_id
#   uniform_bucket_level_access = true
# }