output "vpc_id" {
  description = "ID de la VPC."
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "IDs de las subredes publicas, en orden A y B."
  value       = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "route_table_id" {
  description = "ID de la tabla de rutas publica."
  value       = aws_route_table.public.id
}
