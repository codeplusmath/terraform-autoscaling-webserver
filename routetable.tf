# Route Table Internet Gateway
resource "aws_route_table" "terra_VPC_routetble" {
    vpc_id = aws_vpc.terra_autoscalingwebserver_vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.autoscaling_igw.id
    }

    tags = {
        Name = "Custom Public Subnet in terra VPC"
    }
}

# Associating routes with VPC subnets
resource "aws_route_table_association" "public_vpc_subnet_1a" {
    subnet_id = aws_subnet.autoscaling_ws_sub_1.id
    route_table_id = aws_route_table.terra_VPC_routetble.id
}

resource "aws_route_table_association" "public_vpc_subnet_1b" {
    subnet_id = aws_subnet.autoscaling_ws_sub_2.id
    route_table_id = aws_route_table.terra_VPC_routetble.id
}
