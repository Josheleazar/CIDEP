variable "region" {
  description = "The GCP region to deploy to"
  type        = string
  default     = "me-west1"
}

variable "zone" {
  description = "The GCP zone to deploy to"
  type        = string
  default     = "me-west1-a"
}

variable "node_machine_type" {
  description = "The type of machine to deploy"
  type        = string
  default     = "e2-medium"
}
