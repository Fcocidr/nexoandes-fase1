variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "subnet_id" {
  type        = string
  description = "ID de la subred donde se lanza la instancia."
}

variable "security_group_ids" {
  type        = list(string)
  description = "IDs de los Security Groups asociados a la instancia."
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2."
}

variable "user_data" {
  type        = string
  description = "Contenido ya renderizado del user data del Portal Operacional."
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
