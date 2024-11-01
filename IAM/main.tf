# Referencing the service account 
data "google_service_account" "gke_service_account" {
  project = "cidep-440311"
  account_id = "j4cidep@cidep-440311.iam.gserviceaccount.com"
}

# The Kubernetes Engine Admin role has to be provisioned from the console.

resource "google_project_iam_binding" "gke_sa_viewer_binding" {
  role    = "roles/viewer"
  project = "cidep-440311"
  members = [
    "serviceAccount:${data.google_service_account.gke_service_account.email}"
  ]
}

resource "google_project_iam_binding" "gke_sa_network_admin_binding" {
  role    = "roles/compute.networkAdmin"
  project = "cidep-440311"
  members = [
    "serviceAccount:${data.google_service_account.gke_service_account.email}"
  ]
}

resource "google_project_iam_binding" "gke_sa_resource_admin_binding" {
  role    = "roles/resourcemanager.projectIamAdmin"
  project = "cidep-440311"
  members = [
    "serviceAccount:${data.google_service_account.gke_service_account.email}"
  ]
}

resource "google_project_iam_member" "gke_sa_user_binding" {
  role    = "roles/iam.serviceAccountUser"
  project = "cidep-440311"
  member = "serviceAccount:${data.google_service_account.gke_service_account.email}"
}

