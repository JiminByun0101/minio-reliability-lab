output "node_ips" {
  description = "Public IPs MinIO nodes"
  value       = google_compute_instance.minio_node[*].network_interface[0].access_config[0].nat_ip
}