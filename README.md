# Infrastructure as Code — Invictus

Monorepo de infraestructura multi-cuenta AWS gestionado con **Terraform + Terragrunt**. Contiene **42 módulos reutilizables** y **523+ stacks desplegables** para 48 microservicios/infraestructura compartida.

CI/CD via Azure DevOps con pipeline externo (`DevOps-templates-UX/pipelines-templates`).

---

## Estructura del repositorio

```
iac-template-terraform/modules/aws/   ← 42 módulos Terraform (source of truth)
iac-terragrunt/invictus/              ← 48 stacks Terragrunt
  root.hcl                            ← generate provider.tf + backend.tf
  initial-infrastructure/             ← VPC, RDS, ECS cluster, DynamoDB, S3, etc.
  apps/                               ← CloudFront, S3 buckets, cache policies
  {microservicios}/                   ← ECS, SSM, SQS, S3, IAM, Secrets, EventBridge...
pipeline/main-pipeline.yml            ← Pipeline Azure DevOps entrypoint
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
```

## Importante

- **Placeholders**: Los valores `#{variable}#` son resueltos por el pipeline CI/CD. No ejecutar terragrunt local sin sustituirlos.
- **Dependencies**: Usan `mock_outputs` — planes sin estado previo usarán valores mock.
- **Provider**: AWS provider `~> 6.8.0`.
- **ECS**: Todos los servicios usan Fargate con modo red `awsvpc`.
- **Logs**: CloudWatch logs retention 30 días.
- **State**: S3 backend, cada módulo tiene su propio state file.

## Pipeline

El pipeline en `pipeline/main-pipeline.yml` delega a una plantilla externa en `DevOps-templates-UX/pipelines-templates` (branch `feature/infrastructure-as-code`). Esa plantilla se encarga de la sustitución de placeholders y la orquestación completa.
