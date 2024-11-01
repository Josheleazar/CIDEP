data "google_service_account" "gke_service_account" {
  project = "cidep-440311"
  account_id = "j4cidep@cidep-440311.iam.gserviceaccount.com"
}

resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  # Provision a regional cluster for high availability and increased fault taulerance.
  location = var.cluster_location 
  network  = var.network_name
  subnetwork = var.subnet_name
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  min_master_version = "1.29.9-gke.1177000"
}

# It is recommended practice to create and manage node pools as separate resources.
# This allows node pools to be added and removed without recreating the cluster.
resource "google_container_node_pool" "node_servers" {
    name       = var.node_pool_name
    location   = var.node_location
    cluster    = google_container_cluster.gke_cluster.id
    initial_node_count = 1
    max_pods_per_node = 200

    node_config {
        preemptible  = false
        machine_type = var.node_machine_type
            
        # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
        service_account = data.google_service_account.gke_service_account.email
        oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    }

    autoscaling {
    min_node_count = 1
    max_node_count = 5  # The maximum node count
    }

    # Management settings
    management {
        auto_repair  = true  # Automatically repair unhealthy nodes
        auto_upgrade = true  # Automatically upgrade nodes to newer versions

    }
}