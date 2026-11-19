output "name_prefix" {
  description = "Prefijo de nombres U2 (na-u2-cNN-aNNN)."
  value       = local.name_prefix
}

output "student" {
  description = "Identificador de alumno (aNNN)."
  value       = local.student
}

output "portal_version" {
  description = "Version del Portal configurada en el codigo."
  value       = var.portal_version
}

output "build_ref" {
  description = "Referencia del artefacto desplegado."
  value       = var.build_ref
}

output "vpc_id" {
  description = "ID de la VPC."
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR de la VPC (10.X.0.0/16)."
  value       = local.vpc_cidr
}

output "subnet_ids" {
  description = "IDs de las subredes A y B."
  value       = module.network.subnet_ids
}

output "subnet_cidrs" {
  description = "CIDR de las subredes A y B."
  value       = { for k, s in local.subnets : k => s.cidr }
}

output "alb_dns_name" {
  description = "DNS del ALB: endpoint de servicio del Portal."
  value       = module.alb.dns_name
}

output "portal_url" {
  description = "URL HTTP del Portal detras del ALB."
  value       = "http://${module.alb.dns_name}"
}

output "target_group_arn" {
  description = "ARN del Target Group."
  value       = module.alb.target_group_arn
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group (controlador del reemplazo)."
  value       = module.compute.asg_name
}

output "launch_template_id" {
  description = "ID de la Launch Template."
  value       = module.compute.launch_template_id
}

output "launch_template_version" {
  description = "Version numerada de la Launch Template usada por el ASG."
  value       = module.compute.launch_template_version
}

output "ami_id" {
  description = "AMI fija utilizada."
  value       = var.ami_id
}
