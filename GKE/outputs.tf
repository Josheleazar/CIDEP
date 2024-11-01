output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke_cluster.name
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}

output "gke_cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate
}

output "gke_cluster_kubeconfig" {
  description = "Kubeconfig file content to access the GKE cluster"
  value       = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate}
    server: https://${google_container_cluster.gke_cluster.endpoint}
  name: gke_cluster
contexts:
- context:
    cluster: gke_cluster
    user: gke_user
  name: gke_context
current-context: gke_context
kind: Config
preferences: {}
users:
- name: gke_user
  user:
    auth-provider:
      config:
        cmd-args: "config config-helper --format=json"
        cmd-path: gcloud
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
EOT
}
