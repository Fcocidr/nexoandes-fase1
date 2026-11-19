mock_provider "aws" {}

variables {
  x              = 17
  course         = "c01"
  portal_version = "v1"
  build_ref      = "u2-v1"
  ami_id         = "ami-065101b35d4f06f41"
}

run "direccionamiento_y_nombres_u2" {
  command = plan

  assert {
    condition     = output.vpc_cidr == "10.17.0.0/16"
    error_message = "La VPC debe ser 10.X.0.0/16 con X igual al numero asignado."
  }

  assert {
    condition     = output.subnet_cidrs["a"] == "10.17.10.0/24" && output.subnet_cidrs["b"] == "10.17.20.0/24"
    error_message = "Las subredes deben ser 10.X.10.0/24 (A) y 10.X.20.0/24 (B)."
  }

  assert {
    condition     = output.name_prefix == "na-u2-c01-a017" && output.student == "a017"
    error_message = "El prefijo debe ser na-u2-cNN-aNNN con aNNN a tres digitos."
  }
}

run "seguridad_e_inmutabilidad" {
  command = plan

  assert {
    condition     = module.security.http_port == 80
    error_message = "El Portal debe publicarse por HTTP en el puerto 80."
  }

  assert {
    condition     = module.compute.imds_http_tokens == "required"
    error_message = "Las instancias deben exigir IMDSv2 (http_tokens = required)."
  }

  assert {
    condition     = output.ami_id == "ami-065101b35d4f06f41"
    error_message = "La AMI debe estar fijada por ID para poder reproducir y recuperar la version."
  }
}

run "version_v2_con_su_referencia" {
  command = plan

  variables {
    portal_version = "v2"
    build_ref      = "u2-v2"
  }

  assert {
    condition     = output.portal_version == "v2" && output.build_ref == "u2-v2"
    error_message = "La version objetivo y su build deben reflejarse en el codigo."
  }
}

run "rechaza_x_invalido" {
  command = plan

  variables {
    x = 300
  }

  expect_failures = [var.x]
}

run "rechaza_version_invalida" {
  command = plan

  variables {
    portal_version = "v3"
  }

  expect_failures = [var.portal_version]
}

run "rechaza_ami_invalida" {
  command = plan

  variables {
    ami_id = "ubuntu-latest"
  }

  expect_failures = [var.ami_id]
}
