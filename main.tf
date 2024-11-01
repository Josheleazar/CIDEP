# Configure the Google Cloud Provider
provider "google" {
  project = "cidep-440311"
  region  = var.region
  credentials = file("servicekey.json")  # Path to your service account JSON
}

module "IAM" {
  source = "./IAM"
}

module "VPC" {
  source       = "./VPC"
  depends_on = [ module.IAM ]
  network_name = "cidep-network"
  subnet_name  = "cidep-subnet"
  region       = var.region
  subnet_cidr  = "10.0.0.0/24"
}

module "GCE" {
  source        = "./GCE"
  depends_on    = [ module.VPC ]
  instance_name = "cicd"
  machine_type  = "e2-medium"
  disk_size     = 50
  instance_zone = var.zone
  network_id    = module.VPC.vpc_network_id
  subnet_name   = module.VPC.subnet_name
}

module "GKE" {
  source            = "./GKE"
  depends_on        = [ module.VPC ]
  cluster_name      = "cidep-cluster"
  network_name      = module.VPC.vpc_network_name
  subnet_name       = module.VPC.subnet_name
  cluster_location  = var.region
  node_location     = var.zone
  node_pool_name    = "cidep-pool"
  node_machine_type = var.node_machine_type
}