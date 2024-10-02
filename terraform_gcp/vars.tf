variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "dbg-energy-dev-659ba550"
}
variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-west3"
}
variable "default_labels" {
  type        = map(string)
  description = "Default labels normally set on google provider default_labels field. Cloud SQL instance doesn't use them."
}
variable "location" {
  type        = string
  description = "GCP location used"
}
variable "environment_name" {
  type        = string
  description = "Name of the environment. (module.environment.name)"
}
variable "kms_key_name" {
  type        = string
  description = "KMS key name used CMEK disk encryption"
}
# Private networking
variable "vpc_name" {
  type        = string
  description = "Name of the vpc to use"
}
variable "vpc_project" {
  type        = string
  description = "Project of the vpc to use"
}

variable "metric_read_permission_projects" {
  type        = list(string)
  description = "List of projects grafana should be able to read metrics from"
}

variable "k8s_cluster_gcp_project_name" {
  type        = string
  description = "GCP project of the kubernetes cluster"
  default     = null
}
variable "metric_reader_k8s_service_account" {
  type        = string
  description = "Kubernetes serviceaccount prometheus-frontend/grafana uses"
}

# GKE Azure AD OAuth / IIQ 
variable "enable_azuread" {
  type        = bool
  default     = false
  description = "Wheter grafana platform will be authenticated via Azure AD OAuth - flag necessary for external secrets and service account access"
}

variable "k8s_cluster_name" {
  type        = string
  description = "Name of the gke cluster"
}