resource "aws_security_group" "portal" {
  name        = "${var.name_prefix}-sg-portal"
  description = "Permite HTTP al Portal Operacional NexoAndes"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-sg-portal" })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.portal.id
  description       = "HTTP publico hacia el portal"
  ip_protocol       = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_ipv4         = var.allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.portal.id
  description       = "Salida a Internet para el bootstrap del portal"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
