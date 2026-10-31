output "instance_id" {
  description = "ID de la instancia EC2 del portal."
  value       = module.compute.instance_id
}

output "public_ip" {
  description = "IP publica del portal."
  value       = module.compute.public_ip
}

output "portal_url" {
  description = "URL HTTP del Portal Operacional."
  value       = "http://${module.compute.public_ip}/"
}

output "subnet_cidr" {
  description = "CIDR de la subred publica (172.16.X.0/24)."
  value       = local.subnet_cidr
}

output "vpc_id" {
  description = "ID de la VPC."
  value       = module.network.vpc_id
}
