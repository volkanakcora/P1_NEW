output "instance_name" {
  value = google_sql_database_instance.db_instance.name
}

output "connection_name" {
  value = google_sql_database_instance.db_instance.connection_name
}
