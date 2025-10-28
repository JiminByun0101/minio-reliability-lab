terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.7.0"
}

provider "google" {
  credentials = file("~/.gcp-keys/gcp-key.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
