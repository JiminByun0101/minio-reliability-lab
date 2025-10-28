resource "google_compute_instance" "minio_node" {
  count        = var.node_count
  name         = "minio-node-${count.index}"
  machine_type = "e2-standard-2" 

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 100
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update -y && apt install -y curl jq
  EOT
}
