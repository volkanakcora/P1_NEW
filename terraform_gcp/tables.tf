resource "google_bigquery_table" "sysengdatachange" {
  dataset_id = google_bigquery_dataset.kpi_dataset.dataset_id
  table_id   = "sysengdatachange"
  project    = var.project_id
  schema     = <<EOF
[
  {"name": "id", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "key", "type": "STRING", "mode": "NULLABLE"},
  {"name": "summary", "type": "STRING", "mode": "NULLABLE"},
  {"name": "issuetype", "type": "STRING", "mode": "NULLABLE"},
  {"name": "status", "type": "STRING", "mode": "NULLABLE"},
  {"name": "project", "type": "STRING", "mode": "NULLABLE"},
  {"name": "priority", "type": "STRING", "mode": "NULLABLE"},
  {"name": "assignee", "type": "STRING", "mode": "NULLABLE"},
  {"name": "created", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "labels", "type": "STRING", "mode": "NULLABLE"},
  {"name": "description", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolution", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolutiondate", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "statusdescription", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolved", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "epsenvironment", "type": "STRING", "mode": "NULLABLE"},
  {"name": "epstennant", "type": "STRING", "mode": "NULLABLE"},
  {"name": "servicecatalogue", "type": "STRING", "mode": "NULLABLE"}
]
EOF
}

resource "google_bigquery_table" "sysengdata" {
  dataset_id = google_bigquery_dataset.kpi_dataset.dataset_id
  table_id   = "sysengdata"
  project    = var.project_id
  schema     = <<EOF
[
  {"name": "id", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "key", "type": "STRING", "mode": "NULLABLE"},
  {"name": "summary", "type": "STRING", "mode": "NULLABLE"},
  {"name": "issuetype", "type": "STRING", "mode": "NULLABLE"},
  {"name": "status", "type": "STRING", "mode": "NULLABLE"},
  {"name": "project", "type": "STRING", "mode": "NULLABLE"},
  {"name": "priority", "type": "STRING", "mode": "NULLABLE"},
  {"name": "assignee", "type": "STRING", "mode": "NULLABLE"},
  {"name": "created", "type": "STRING", "mode": "NULLABLE"},
  {"name": "labels", "type": "STRING", "mode": "NULLABLE"},
  {"name": "description", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolution", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolutiondate", "type": "STRING", "mode": "NULLABLE"},
  {"name": "statusdescription", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolved", "type": "STRING", "mode": "NULLABLE"},
  {"name": "timetofirstresponse", "type": "STRING", "mode": "NULLABLE"},
  {"name": "timetoresolution", "type": "STRING", "mode": "NULLABLE"},
  {"name": "firstresponsebreached", "type": "STRING", "mode": "NULLABLE"},
  {"name": "resolutionbreached", "type": "STRING", "mode": "NULLABLE"},
  {"name": "epsenvironment", "type": "STRING", "mode": "NULLABLE"},
  {"name": "epstennant", "type": "STRING", "mode": "NULLABLE"},
  {"name": "servicetype", "type": "STRING", "mode": "NULLABLE"},
  {"name": "laststatuschange", "type": "STRING", "mode": "NULLABLE"}
]
EOF
}