variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "vpc_cidr" {
  type        = string
  description = "Bloque CIDR de la VPC (10.X.0.0/16)."
}

variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Subredes publicas por clave (a, b) con su CIDR y zona de disponibilidad."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
