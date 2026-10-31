output "vpc_id" {
  description = "ID de la VPC."
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID de la subred publica."
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "route_table_id" {
  description = "ID de la tabla de rutas publica."
  value       = aws_route_table.public.id
}
