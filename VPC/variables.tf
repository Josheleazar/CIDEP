variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "region" {
  description = "The region for your network"
  type = string
}
