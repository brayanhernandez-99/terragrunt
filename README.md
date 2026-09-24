# Infrastructure as Code — Invictus

Monorepo de infraestructura multi-cuenta AWS gestionado con **Terraform + Terragrunt**. Contiene **39 módulos reutilizables** y **504 stacks desplegables** distribuidos en **50 directorios** de microservicios/infraestructura compartida.

CI/CD via Azure DevOps con pipeline externo (`DevOps-templates-UX/pipelines-templates`).

---

## Estructura del repositorio

```
iac-template-terraform/modules/aws/   ← 39 módulos Terraform (source of truth)
iac-terragrunt/invictus/              ← 50 directorios de stacks Terragrunt
  root.hcl                            ← genera provider.tf + backend.tf
  initial-infrastructure/             ← VPC, RDS, ECS cluster, DynamoDB, S3, etc.
  apps/                               ← CloudFront, S3 buckets, cache policies
  {microservicios}/                   ← ECS, SSM, SQS, S3, IAM, Secrets, EventBridge...
pipeline/main-pipeline.yml            ← Entrypoint del pipeline Azure DevOps
```

## Ramas y entornos

| Rama | Entorno |
|------|---------|
| `develop` | dev |
| `staging` | staging |
| `master` | production |

Solo estas 3 ramas disparan pipeline.

## Requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) >= 0.55
- Acceso a la cuenta AWS correspondiente

## Uso básico

```bash
# Inicializar un módulo
terragrunt init

# Planificar un módulo
terragrunt plan

# Planificar todos los módulos
terragrunt run-all plan

# Formatear código
terraform fmt -recursive

# Validar un módulo
terraform validate
```

## Importante

- **Placeholders**: Los valores `#{variable}#` (ej. `#{aws_region}#`, `#{aws_environment}#`, `#{aws_bucket}#`, `#{aws_cliente}#`) son resueltos por el pipeline CI/CD. No ejecutar terragrunt local sin sustituirlos.
- **Dependencies**: Usan `mock_outputs` — planes sin estado previo usarán valores mock.
- **Provider**: AWS provider fijado a `= 6.8.0` (pin exacto en `root.hcl`).
- **ECS**: Todos los servicios usan Fargate con modo red `awsvpc`.
- **Logs**: Retención de logs de CloudWatch a 30 días en los recursos donde se configura.
- **State**: Backend S3, cada módulo tiene su propio state file (key derivada de `path_relative_to_include()`).
- **Archivos generados**: `root.hcl` autogenera `provider.tf` y `backend.tf` en cada directorio. No editarlos manualmente.
- **.gitignore**: Excluye artefactos locales de Terraform/Terragrunt (`.terraform/`, `.tfstate*`, `.tfvars`, `.terragrunt-cache/`).

## Pipeline

El pipeline en `pipeline/main-pipeline.yml` delega a una plantilla externa en `DevOps-templates-UX/pipelines-templates` (branch `feature/infrastructure-as-code`). Esa plantilla se encarga de la sustitución de placeholders y la orquestación completa.
