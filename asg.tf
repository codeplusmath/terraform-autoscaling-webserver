# ASG(Auto Scaling Group) Part
resource "aws_autoscaling_group" "terra_asg" {
    name = "terra_asg"
    target_group_arns = [aws_lb_target_group.terra_alb_target_grp.arn]

    health_check_type = "ELB"
    health_check_grace_period = 30

    vpc_zone_identifier = [aws_subnet.autoscaling_ws_sub_1.id, aws_subnet.autoscaling_ws_sub_2.id]


    desired_capacity = 2
    max_size = 4
    min_size = 1

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"

    launch_template {
        id = local.launch_template_id
        version = "$Latest"
    }

    tag {
        key = "Name"
        value = "Terra_asg"
        propagate_at_launch = true
    }
}

# AutoScaling Policies
# Scale Up Policy
resource "aws_autoscaling_policy" "terra_scaleup" {
    name = "terra_scaleup"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 30
    autoscaling_group_name = aws_autoscaling_group.terra_asg.name
}

# Cloudwatch Alarm
resource "aws_cloudwatch_metric_alarm" "terra_scaleup_alarm" {
    alarm_name = "terra_scaleup_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCountPerTarget"

    namespace = "AWS/ApplicationELB"
    period = "60"
    statistic = "Sum"
    threshold = "100"

    dimensions = {
        TargetGroup = aws_lb_target_group.terra_alb_target_grp.arn_suffix
        LoadBalancer = aws_lb.terra_alb.arn_suffix
    }

    alarm_description = "Trigger when recieve more that 100 requests in 60 sec for alb"
    alarm_actions = [aws_autoscaling_policy.terra_scaleup.arn]
}

# Scale Down Policy
resource "aws_autoscaling_policy" "terra_scaledown" {
    name = "terra_scaledown"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 30
    autoscaling_group_name = aws_autoscaling_group.terra_asg.name
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "terra_scaledown_alarm" {
    alarm_name = "terra_scaledown_alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "RequestCountPerTarget"

    namespace = "AWS/ApplicationELB"
    period = "60"
    statistic = "Sum"
    threshold = "100"

    dimensions = {
        TargetGroup = aws_lb_target_group.terra_alb_target_grp.arn_suffix
        LoadBalancer = aws_lb.terra_alb.arn_suffix
    }

    alarm_description = "Trigger when recieve less that 100 requests in 60 sec for alb"
    alarm_actions = [aws_autoscaling_policy.terra_scaledown.arn]
}
