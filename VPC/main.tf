resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_network.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr //This is within standard private IP ranges, and allows for
                                //only 255 hosts since its for a demo project.
}