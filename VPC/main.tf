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

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allows SSH from any IP. Adjust for stricter access control.
  target_tags   = ["allow-ssh"] # Add this tag to instances that should allow SSH access.
  depends_on = [ google_compute_network.vpc_network ]
}
