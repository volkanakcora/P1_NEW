provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "google_sql_database_instance" "db_instance" {
  name             = "example-sql-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"  # Use appropriate machine type based on your need

    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = "default"
    }
  }
}

resource "google_sql_database" "database" {
  name     = "exampledb"
  instance = google_sql_database_instance.db_instance.name
}

resource "google_sql_user" "users" {
  name     = "exampleuser"
  instance = google_sql_database_instance.db_instance.name
  password = "YourSecurePassword"
}
