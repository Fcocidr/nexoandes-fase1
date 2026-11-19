variable "name_prefix" {
  type        = string
  description = "Prefijo comun para los nombres de los recursos."
}

variable "ami_id" {
  type        = string
  description = "ID fijo de la AMI."
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2."
}

variable "user_data" {
  type        = string
  description = "Bootstrap ya renderizado del Portal (sin codificar)."
}

variable "security_group_id" {
  type        = string
  description = "Security Group de las instancias."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subredes A y B donde se lanzan las instancias."
}

variable "target_group_arn" {
  type        = string
  description = "Target Group del ALB que recibe las instancias."
}

variable "desired_capacity" {
  type        = number
  description = "Capacidad base fija (instancias en servicio)."
}

variable "max_capacity" {
  type        = number
  description = "Limite de capacidad que admite la capacidad temporal del reemplazo."
}

variable "health_check_grace_period" {
  type        = number
  description = "Segundos de gracia para que el bootstrap termine antes de evaluar la salud."
  default     = 180
}

variable "tags" {
  type        = map(string)
  description = "Etiquetas comunes que se aplican a los recursos."
}
