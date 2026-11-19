output "alb_security_group_id" {
  description = "ID del Security Group del ALB."
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID del Security Group de las instancias."
  value       = aws_security_group.ec2.id
}

output "http_port" {
  description = "Puerto HTTP habilitado."
  value       = var.http_port
}
