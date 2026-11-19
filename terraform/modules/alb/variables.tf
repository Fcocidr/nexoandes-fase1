variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC del Target Group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subredes publicas A y B donde opera el ALB."
}

variable "security_group_id" {
  type        = string
  description = "Security Group del ALB."
}

variable "health_check_path" {
  type        = string
  description = "Ruta del health check funcional del Portal."
  default     = "/api/check"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
