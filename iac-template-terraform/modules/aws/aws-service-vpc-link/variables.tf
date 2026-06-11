variable "vpc_link" {
  description = "vpc link asociado a la api gateway"
  type        = string
}

variable "nlb_arn" {
  description = "arn del load balancer"
  type        = string
}

variable "nlb_dns_name" {
  description = "dns del load balancer"
  type        = string
}