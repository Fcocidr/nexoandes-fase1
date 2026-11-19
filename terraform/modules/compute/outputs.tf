output "launch_template_id" {
  description = "ID de la Launch Template."
  value       = aws_launch_template.portal.id
}

output "launch_template_version" {
  description = "Version numerada de la Launch Template usada por el ASG."
  value       = aws_launch_template.portal.latest_version
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group."
  value       = aws_autoscaling_group.portal.name
}

output "imds_http_tokens" {
  description = "Modo de tokens de IMDS (required = IMDSv2)."
  value       = aws_launch_template.portal.metadata_options[0].http_tokens
}
