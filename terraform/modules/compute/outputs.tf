output "instance_id" {
  description = "ID de la instancia EC2."
  value       = aws_instance.portal.id
}

output "public_ip" {
  description = "IP publica de la instancia."
  value       = aws_instance.portal.public_ip
}

output "private_ip" {
  description = "IP privada de la instancia."
  value       = aws_instance.portal.private_ip
}

output "imds_http_tokens" {
  description = "Modo de tokens de IMDS configurado (required = IMDSv2)."
  value       = aws_instance.portal.metadata_options[0].http_tokens
}
