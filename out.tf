# VPC id
output "terraform_vpc_id" {
  value = local.terra_vpc_id
}

# ALB DNS
output "terra_alb_dns" {
  value = local.alb_dns
}
