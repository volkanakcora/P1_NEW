resource "google_bigquery_dataset" "kpi_dataset" {
  dataset_id = "kpi_dataset"
  location   = var.region
  project    = var.project_id
}