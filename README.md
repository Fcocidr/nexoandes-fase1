# NexoAndes - Fase 1: Portal Operacional V1 (IaC)

Infraestructura como Código (Terraform) para desplegar el Portal Operacional NexoAndes V1 en AWS, con flujo Git de revisión y pipeline CI/CD en GitHub Actions.
Evaluación Sumativa U1 - Automatización de Infraestructura con IaC (IC106TICL).

## Arquitectura

VPC `172.16.0.0/16` -> subred pública `172.16.X.0/24` (X = número de lista) -> Internet Gateway + Route Table (`0.0.0.0/0` hacia el IGW) -> Security Group (HTTP/80 de entrada, sin SSH) -> una instancia EC2 (Amazon Linux 2023) que publica el portal mediante `user_data` (plantilla entregada por el docente, sin modificar). La instancia exige IMDSv2.

## Estructura del repositorio

```text
.
|-- .github/workflows/terraform.yml   Pipeline CI/CD
|-- .gitignore                        Excluye state, planes, .terraform/ y credenciales
|-- .trivyignore                      Excepciones justificadas del análisis de seguridad
|-- README.md
`-- terraform/
    |-- versions.tf                   required_version y required_providers
    |-- backend.tf / backend.hcl      Backend remoto S3 con locking (sin credenciales)
    |-- providers.tf                  Provider AWS
    |-- variables.tf                  Entradas del root module (con validación)
    |-- main.tf                       locals, templatefile() y composición de módulos
    |-- outputs.tf                    Instance ID, IP pública, URL, CIDR
    |-- fase1.tfvars                  Valores de identificación (sin secretos)
    |-- .terraform.lock.hcl           Bloqueo de providers (se versiona)
    |-- templates/user_data_v1.sh.tpl Plantilla del docente (sin modificar)
    |-- tests/fase1.tftest.hcl        Prueba IaC con aserciones
    `-- modules/
        |-- network/                  VPC, subred pública, IGW, route table y asociación
        |-- security/                 Security Group y reglas
        `-- compute/                  Data source de AMI e instancia EC2
```

## Composición de módulos

`network` expone `vpc_id` y `subnet_id` -> `security` recibe `vpc_id` -> `compute` recibe `subnet_id` y `security_group_id`. El módulo `compute` declara `depends_on = [module.network]` para garantizar que la ruta a Internet exista antes de que la instancia ejecute el bootstrap.

## Prerrequisitos

Git, Terraform (>= 1.10; probado con 1.16.6), AWS CLI y una cuenta de GitHub. Acceso a AWS mediante las credenciales temporales del laboratorio.

## Flujo de trabajo Git

- Rama principal: `main` (protegida por el flujo: no se desarrolla directamente en ella).
- Rama de trabajo: `feature/fase1-portal`.
- Convención de commits: **Conventional Commits** (`feat:`, `fix:`, `chore:`, `docs:`, `test:`, `ci:`), con commits atómicos.
- Los cambios se integran a `main` mediante **pull request**, con los controles automáticos del pipeline como verificación previa al merge.

## Pipeline (GitHub Actions)

| Etapa | Qué hace | Criterio de avance / bloqueo |
|---|---|---|
| Trigger | `pull_request` y `push` a `main` (rutas `terraform/**`), o ejecución manual (`plan`, `apply`, `destroy`) | - |
| Controles | `terraform fmt -check`, `validate`, `terraform test`, TFLint, Trivy (config) | Si un control falla, el pipeline se detiene |
| Plan | `terraform plan` con backend remoto; el plan se publica en el resumen del job | Debe revisarse e interpretarse antes de aprobar |
| Gate | Environment `aprobacion` con revisor obligatorio | Sin aprobación manual no se ejecuta apply ni destroy |
| Apply | `terraform apply` del plan aprobado | Solo con aprobación |
| Verificación | Outputs + consulta AWS CLI + HTTP + plan posterior (0 cambios) | Falla si no hay HTTP 200 o si el plan posterior propone cambios |
| Destroy | `terraform destroy` + consulta independiente de limpieza | Solo con aprobación (ejecución manual) |

Controles de seguridad: el análisis con Trivy bloquea hallazgos HIGH/CRITICAL. Las excepciones (HTTP/80 público, salida a Internet para el bootstrap y IP pública en la subred) están justificadas en `.trivyignore` porque son requisitos de la arquitectura de referencia.

## State, autenticación y secretos

- **State:** backend remoto en un bucket S3 privado con versionado y bloqueo (`use_lockfile`). El state nunca se versiona en Git.
- **Autenticación:** credenciales temporales del laboratorio, guardadas como *GitHub Secrets* (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`). No existen credenciales en el código, el repositorio ni el ZIP.

## Despliegue y limpieza

1. Abrir un pull request desde `feature/fase1-portal` hacia `main`; esperar los controles en verde y hacer merge.
2. El push a `main` ejecuta controles -> plan -> gate -> apply -> verificación.
3. Para retirar la infraestructura: Actions -> `terraform-nexoandes-fase1` -> Run workflow -> `destroy` (con aprobación).
4. Eliminar el bucket de state cuando ya no se necesite.

## Decisiones

- GitHub y GitHub Actions como plataforma de repositorio y CI/CD (sin plataforma obligatoria en el diagrama).
- Etiquetas según el diagrama: `StudentNumber`, `Project = NexoAndes`, `Phase = Fase1`.
- Tipo de instancia como variable (`instance_type`, por defecto `t3.micro`).

## Referencias

HashiCorp. (s. f.). *Terraform documentation*. https://developer.hashicorp.com/terraform

Instituto Profesional San Sebastián. (2026). *Apunte Activador 1: Infraestructura como código, versionamiento y despliegue automatizado*.
