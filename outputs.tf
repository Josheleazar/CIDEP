output "instance_ip" {
  description = "The public IP of the instance"
  value       = module.GCE.instance_ip
}
