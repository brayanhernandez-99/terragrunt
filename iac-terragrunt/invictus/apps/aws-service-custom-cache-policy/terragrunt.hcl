include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/iac-template-terraform/modules/aws/aws-service-custom-cache-policy"
}

inputs = {
  name          = "invictus-custom-cache-policy"  
  comment       = "Politica de cache para la distribución de CloudFront"
  default_ttl   = 3600    # 1 hora
  max_ttl       = 86400   # 1 día
  min_ttl       = 0       # sin mínimo (respeta headers del origen)
}
