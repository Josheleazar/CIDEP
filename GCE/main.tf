resource "google_compute_instance" "cicd_server" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.instance_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = var.disk_size
    }
  }

  network_interface {
    network = var.network_id
    subnetwork = var.subnet_name
    access_config {}
  }

  metadata = {
    ssh-keys = "Josh:${file("cidep_public.pub")}"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y docker.io google-cloud-sdk
    sudo apt install -y google-cloud-sdk-gke-gcloud-auth-plugin
  EOF
}
