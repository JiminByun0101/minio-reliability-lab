# 1. Create a dedicated VPC
resource "google_compute_network" "lab_vpc" {
  name                    = "minio-lab-vpc"
  auto_create_subnetworks = false
}

# 2. Create a subnet for your region
resource "google_compute_subnetwork" "lab_subnet" {
  name          = "minio-lab-subnet"
  ip_cidr_range = "10.128.0.0/20"
  region        = var.region
  network       = google_compute_network.lab_vpc.id
}

# 2-1. Reserved external IPs for each VM
resource "google_compute_address" "node_ip" {
  count  = var.node_count
  name   = "minio-node-ip-${count.index}"
  region = var.region
}


# 3. Allow internal communication between all nodes
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.lab_vpc.name

  # Kubernetes control plane
  allow {
    protocol = "tcp"
    ports    = ["6443", "2379-2380", "10250-10252"]
  }
  # MinIO cluster ports (9000–9001 for API, 9002 for console)
  allow {
    protocol = "tcp"
    ports    = ["9000-9002"]
  }
  # Flannel VXLAN overlay network
  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  source_ranges = ["10.128.0.0/20"]
}

# 4. Allow external SSH and API access
resource "google_compute_firewall" "allow_external" {
  name    = "allow-external"
  network = google_compute_network.lab_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 5. Provision the MinIO node instances
resource "google_compute_instance" "minio_node" {
  count        = var.node_count
  name         = "minio-node-${count.index}"
  machine_type = "e2-standard-2"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.lab_vpc.id
    subnetwork = google_compute_subnetwork.lab_subnet.id
    # Attach reserved static external IP
    access_config {
      nat_ip = google_compute_address.node_ip[count.index].address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update -y && apt install -y curl jq
  EOT
}
