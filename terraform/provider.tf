terraform {
  backend "gcs" {
    bucket = "minio-lab-haren-terraform-state"
    prefix = "state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.7.0"
}

locals {
  creds_json = var.google_credentials != "" ? var.google_credentials : file("~/.gcp-keys/gcp-key.json")
}

provider "google" {
  credentials = local.creds_json
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
