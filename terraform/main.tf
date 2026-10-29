locals {
  name_prefix = "nexoandes-fase1-${var.student_number}"
  subnet_cidr = cidrsubnet(var.vpc_cidr, 8, var.student_number)

  common_tags = {
    StudentNumber = tostring(var.student_number)
    Project       = "NexoAndes"
    Phase         = "Fase1"
    ManagedBy     = "terraform"
  }

  portal_user_data = templatefile("${path.module}/templates/user_data_v1.sh.tpl", {
    student_name   = var.student_name
    student_number = tostring(var.student_number)
    environment    = var.environment
    portal_version = var.portal_version
    project_name   = var.project_name
  })
}

module "network" {
  source = "./modules/network"

  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = local.subnet_cidr
  tags        = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  tags        = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  name_prefix        = local.name_prefix
  subnet_id          = module.network.subnet_id
  security_group_ids = [module.security.security_group_id]
  instance_type      = var.instance_type
  user_data          = local.portal_user_data
  tags               = local.common_tags

  # Dependencia explicita: la instancia necesita la ruta a Internet lista antes de arrancar,
  # porque el bootstrap descarga nginx.
  depends_on = [module.network]
}
