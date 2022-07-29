# AWS security group for Application Load Balancer(ALB)
resource "aws_security_group" "terra_alb_http" {
    name = "terra_alb_http"
    vpc_id = local.terra_vpc_id

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags  = {
      Name = "Only HTTP inbound & ALL protocols outbound"
    }
}

# AWS target group for VPC & ALB
resource "aws_lb_target_group" "terra_alb_target_grp" {
  name     = "terra-alb-target-grp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.terra_vpc_id
}
