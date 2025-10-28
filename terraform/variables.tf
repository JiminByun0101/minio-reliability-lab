variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region"     { 
  description = "GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone"       {
  description = "GCP zone to deploy resources"
  type        = string
  default     = "us-central1-a" 
}

variable "node_count" {
  description = "Number of MinIO nodes to create"
  type        = string
  default     = 4
}
