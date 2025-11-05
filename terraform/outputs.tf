output "vpc_network" {
  description = "Name of the VPC network"
  value       = google_compute_network.lab_vpc.name
}

output "subnet_cidr" {
  description = "Subnet CIDR range"
  value       = google_compute_subnetwork.lab_subnet.ip_cidr_range
}

output "node_ips" {
  description = "Public IPs of MinIO nodes"
  value       = google_compute_instance.minio_node[*].network_interface[0].access_config[0].nat_ip
}
