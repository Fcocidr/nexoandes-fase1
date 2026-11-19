locals {
  student     = format("a%03d", var.x)
  name_prefix = "na-u2-${var.course}-${local.student}"
  vpc_cidr    = "10.${var.x}.0.0/16"

  subnets = {
    a = { cidr = cidrsubnet(local.vpc_cidr, 8, 10), az = var.availability_zones[0] }
    b = { cidr = cidrsubnet(local.vpc_cidr, 8, 20), az = var.availability_zones[1] }
  }

  common_tags = {
    proyecto  = "NexoAndes"
    fase      = "U2"
    alumno    = local.student
    curso     = var.course
    proveedor = "aws"
  }

  # Artefacto docente: una sola plantilla para v1 y v2; la version se elige con portal_version.
  portal_user_data = templatefile("${path.module}/templates/user_data_u2.sh.tpl", {
    provider       = "aws"
    x              = var.x
    student        = local.student
    course         = var.course
    build_ref      = var.build_ref
    portal_version = var.portal_version
  })
}

module "network" {
  source = "./modules/network"

  name_prefix = local.name_prefix
  vpc_cidr    = local.vpc_cidr
  subnets     = local.subnets
  tags        = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  tags        = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.subnet_ids
  security_group_id = module.security.alb_security_group_id
  tags              = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  name_prefix       = local.name_prefix
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  user_data         = local.portal_user_data
  security_group_id = module.security.ec2_security_group_id
  subnet_ids        = module.network.subnet_ids
  target_group_arn  = module.alb.target_group_arn
  desired_capacity  = var.desired_capacity
  max_capacity      = var.max_capacity
  tags              = local.common_tags

  # La ruta a Internet debe existir antes de que las instancias ejecuten el bootstrap.
  depends_on = [module.network]
}
