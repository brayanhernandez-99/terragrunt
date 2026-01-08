resource "aws_api_gateway_vpc_link" "vpc_link" {
  name = var.vpc_link
  target_arns = [var.nlb_arn] 
}

resource "aws_vpc_endpoint_service" "endpo_service" {
  acceptance_required        = false
  network_load_balancer_arns = [var.nlb_arn]
}
