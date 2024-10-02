terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "4.45.0"
    }
}

provider "google" {
    project = "xxx"
    region = "us-central1"
    zone = "us-central1-c"
    credentials = ""
}