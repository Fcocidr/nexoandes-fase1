mock_provider "aws" {}

variables {
  student_name   = "Estudiante Prueba"
  student_number = 17
}

run "direccionamiento_usa_numero_de_lista" {
  command = plan

  assert {
    condition     = output.subnet_cidr == "172.16.17.0/24"
    error_message = "La subred debe ser 172.16.X.0/24 con X igual al numero de lista."
  }
}

run "seguridad_http_e_imdsv2" {
  command = plan

  assert {
    condition     = module.security.http_port == 80
    error_message = "El Security Group debe habilitar HTTP en el puerto 80."
  }

  assert {
    condition     = module.compute.imds_http_tokens == "required"
    error_message = "La instancia debe exigir IMDSv2 (http_tokens = required)."
  }
}

run "rechaza_numero_de_lista_invalido" {
  command = plan

  variables {
    student_number = 300
  }

  expect_failures = [var.student_number]
}
