variable "aws_region" {
  type        = string
  description = "Region de AWS autorizada para el laboratorio."
  default     = "us-east-1"
}

variable "x" {
  type        = number
  description = "Numero X del estudiante (1 a 254); define la VPC 10.X.0.0/16 y la identidad aNNN."

  validation {
    condition     = var.x >= 1 && var.x <= 254 && floor(var.x) == var.x
    error_message = "x debe ser un entero entre 1 y 254."
  }
}

variable "course" {
  type        = string
  description = "Codigo de curso con formato cNN (por ejemplo c01)."

  validation {
    condition     = can(regex("^c[0-9]{2}$", var.course))
    error_message = "course debe tener el formato cNN (por ejemplo c01)."
  }
}

variable "portal_version" {
  type        = string
  description = "Version del Portal que se despliega en AWS (v1 o v2)."

  validation {
    condition     = contains(["v1", "v2"], var.portal_version)
    error_message = "portal_version debe ser v1 o v2."
  }
}

variable "build_ref" {
  type        = string
  description = "Referencia real del artefacto desplegado (etiqueta Git del commit, por ejemplo u2-v1)."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]{4,80}$", var.build_ref))
    error_message = "build_ref debe tener entre 4 y 80 caracteres: letras, numeros, punto, guion o guion bajo."
  }
}

variable "ami_id" {
  type        = string
  description = "ID fijo de la AMI (Amazon Linux 2023). Se fija para poder reproducir y recuperar la version."

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
    error_message = "ami_id debe ser un ID de AMI valido (ami-...)."
  }
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2 del laboratorio."
  default     = "t3.micro"
}

variable "availability_zones" {
  type        = list(string)
  description = "Dos zonas de disponibilidad distintas para las subredes A y B."
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Se requieren exactamente dos zonas de disponibilidad distintas."
  }
}

variable "desired_capacity" {
  type        = number
  description = "Capacidad base fija del grupo (instancias en servicio)."
  default     = 2
}

variable "max_capacity" {
  type        = number
  description = "Limite que admite la capacidad temporal durante el reemplazo (no es autoescalamiento)."
  default     = 3

  validation {
    condition     = var.max_capacity >= 2
    error_message = "max_capacity debe ser al menos 2."
  }
}
