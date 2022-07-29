# ALB(application Load Balancer Part)
resource "aws_lb" "terra_alb" {
    name = "terra-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.terra_alb_http.id]
    subnets = [aws_subnet.autoscaling_ws_sub_1.id, aws_subnet.autoscaling_ws_sub_2.id]

    tags = {
        Name = "Terra ALB"
    }
}

# ALB listener for forwarding http traffic
resource "aws_lb_listener" "terra_alb_listener" {
  load_balancer_arn = local.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terra_alb_target_grp.arn
  }
}
