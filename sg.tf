# AWS security groups for VPC & ASG
resource "aws_security_group" "terra_sg" {
    name = "terra_sg"
    description = "Allow http connection"
    vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id

    ingress {
        description = "HTTP connection inbound"
        from_port = 80

        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH connection inbound"
        from_port = 22

        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terra_sg"
    }
}
