# AWS Virtual Private Cloud (VPC)
resource "aws_vpc" "terra_autoscalingwebserver_vpc" {
    cidr_block = var.VPC_CIDR_BLOCK             # associating CIDR block (11.0.0.0/24)

    tags = {
        Name = "Terra Auto Scaling Webserver"
    }
}

# AWS subnet 1 in ap-south-1a region
resource "aws_subnet" "autoscaling_ws_sub_1" {
    vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id          # creating subnet in custom VPC
    cidr_block = var.SUBNET_CIDR_BLOCK_1          # CIDR Block - 11.0.0.0/25 (0-127 ip addresses available)
    availability_zone = "ap-south-1a"

    tags = {
        Name = "AutoScalingWebserver subnet 1"
    }
}

# AWS subnet 2 in ap-south-1b region
resource "aws_subnet" "autoscaling_ws_sub_2" {
    vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id          # creating subnet in custom VPC
    cidr_block = var.SUBNET_CIDR_BLOCK_2          # CIDR Block - 11.0.0.128/25 (128-255 ip addresses available)
    availability_zone = "ap-south-1b"

    tags = {
        Name = "AutoScalingWebserver subnet 2"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "autoscaling_igw" {
    vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id

    tags = {
        Name = "Internet Gateway"
    }
}
