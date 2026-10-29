output "security_group_id" {
  description = "ID del Security Group del portal."
  value       = aws_security_group.portal.id
}

output "http_port" {
  description = "Puerto HTTP habilitado en el Security Group."
  value       = var.http_port
}
