variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC donde se crean los Security Groups."
}

variable "http_port" {
  type        = number
  description = "Puerto HTTP del Portal."
  default     = 80
}

variable "allowed_cidr" {
  type        = string
  description = "Origen permitido para el ingreso HTTP al ALB."
  default     = "0.0.0.0/0"
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
