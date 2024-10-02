variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "db_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Password for the database user"
  type        = string
}

variable "region" {
  description = "Region to deploy the SQL instance"
  type        = string
  default     = "us-central1"
}
