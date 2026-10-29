variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "vpc_cidr" {
  type        = string
  description = "Bloque CIDR de la VPC."
}

variable "subnet_cidr" {
  type        = string
  description = "Bloque CIDR de la subred publica."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
