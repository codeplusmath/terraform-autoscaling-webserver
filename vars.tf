# AWS account Access & Secret key variables
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

# ap-south-1 i.e. Mumbai Region
variable "AWS_REGION" {
    default = "ap-south-1"
}

# CIDR (Classless Inter-Domain Routing also called as supernetting) block of VPC
variable "VPC_CIDR_BLOCK" {
    default = "11.0.0.0/24"
}

# CIDR block of subnet 1 (az=ap-south-1a)
variable "SUBNET_CIDR_BLOCK_1" {
    default = "11.0.0.0/25"
}

# CIDR block of subnet 2 (az=ap-south-1b)
variable "SUBNET_CIDR_BLOCK_2" {
    default = "11.0.0.128/25"
}

# AZ(Availability Zones) for vpc
variable "AVAIL_ZONES" {
    default = ["ap-south-1a", "ap-south-1b"]
}

# Local Variables to store Dynamic resource ids
locals {
    terra_vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id          # VPC id created using terraform
    alb_dns = aws_lb.terra_alb.dns_name          # ALB dns name
    alb_arn =  aws_lb.terra_alb.arn          # ALB arn
    launch_template_id = aws_launch_template.terra_lt.id          # Launch Template id
}
