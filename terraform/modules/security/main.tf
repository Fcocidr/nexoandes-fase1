resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-aws-sg-alb"
  description = "ALB del Portal NexoAndes U2: HTTP desde origenes autorizados"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-aws-sg-alb" })
}

resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix}-aws-sg-ec2"
  description = "Instancias del Portal NexoAndes U2: HTTP solo desde el SG del ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-aws-sg-ec2" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP desde origenes autorizados hacia el ALB"
  ip_protocol       = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_ipv4         = var.allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ec2" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Trafico del ALB hacia las instancias y su health check"
  ip_protocol                  = "tcp"
  from_port                    = var.http_port
  to_port                      = var.http_port
  referenced_security_group_id = aws_security_group.ec2.id
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id            = aws_security_group.ec2.id
  description                  = "HTTP del Portal solo desde el SG del ALB"
  ip_protocol                  = "tcp"
  from_port                    = var.http_port
  to_port                      = var.http_port
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2.id
  description       = "Salida HTTPS para el bootstrap y dependencias"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2.id
  description       = "Salida HTTP para repositorios del sistema durante el bootstrap"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}
