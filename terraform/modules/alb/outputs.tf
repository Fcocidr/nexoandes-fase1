output "dns_name" {
  description = "DNS del ALB."
  value       = aws_lb.this.dns_name
}

output "arn" {
  description = "ARN del ALB."
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "ARN del Target Group."
  value       = aws_lb_target_group.portal.arn
}
