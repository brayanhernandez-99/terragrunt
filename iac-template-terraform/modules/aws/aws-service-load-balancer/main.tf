resource "aws_lb" "nlb" {
  name                             = var.nlb_name
  internal                         = var.nlb_internal
  load_balancer_type               = "network"
  subnets                          = var.subnet_ids
  enable_deletion_protection       = true
  enable_cross_zone_load_balancing = true
}
