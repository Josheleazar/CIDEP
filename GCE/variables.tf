variable "instance_name" {
  description = "The name of the instance"
  type = string
}

variable "machine_type" {
  description = "The name of the machine"
  type = string
}

variable "instance_zone" {
  description = "The zone in which the instance is created"
  type = string
}

variable "disk_size" {
  description = "Size of the disk"
  type = number
}

variable "network_id" {
  type = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}