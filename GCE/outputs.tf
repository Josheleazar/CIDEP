output "instance_id" {
  description = "The ID of the compute instance"
  value       = google_compute_instance.cicd_server.id
}

output "instance_name" {
  description = "The name of the compute instance"
  value       = google_compute_instance.cicd_server.name
}

output "instance_ip" {
  description = "The external IP address of the compute instance"
  value       = google_compute_instance.cicd_server.network_interface.0.access_config.0.nat_ip
}

output "instance_self_link" {
  description = "The self-link of the compute instance"
  value       = google_compute_instance.cicd_server.self_link
}
