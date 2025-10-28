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
  credentials = jsondecode(var.google_credentials)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

variable "google_credentials" {
  description = "Google Cloud credentials as JSON"
  type        = string
  default     = ""
}
