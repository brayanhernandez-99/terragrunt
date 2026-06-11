resource "random_password" "password" {
  special = false
  length  = var.length
  numeric = var.numeric
  upper   = var.upper
  lower   = var.lower
}
