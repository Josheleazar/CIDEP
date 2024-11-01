variable "cluster_name" {
  description = "Name of the cluster"
  type = string
}

variable "cluster_location" {
  description = "The location of your cluster. A GCP region."
  type = string
}

variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "node_machine_type" {
  description = "The kind of server to provision"
  type = string
}

variable "node_pool_name" {
  description = "Name of the node pool"
  type = string
}

variable "node_location" {
  description = "Either zone or region. Zone must be part of cluster region, and region must be same as that of the cluster"
  type = string
}