# AMI part
# EC2 instance with Apache2 webserver & website for AMI
resource "aws_instance" "terra_ec2_for_ami" {
    ami = "ami-08df646e18b182346" # ap-south-1
    instance_type = "t2.micro"

    subnet_id = aws_subnet.autoscaling_ws_sub_1.id
    security_groups = [aws_security_group.terra_sg.id]

    associate_public_ip_address = true
    key_name = "AWS_AMI"          # key-pair for ssh login && installing webserver with website
    user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
sudo yum install -y curl
sudo curl -L -O https://github.com/codeplusmath/autoscaling-website/archive/refs/heads/master.zip
sudo unzip master.zip
sudo cp -r ./autoscaling-website-master/* /var/www/html/
EOF

    tags = {
      Name = "Terra_ec2"
    }
}

# Creating AMI from above instance
resource "aws_ami_from_instance" "terra_ami" {
    name = "terra_ami"
    source_instance_id = aws_instance.terra_ec2_for_ami.id

    tags = {
      Name = "Terra_AMI"
    }
}


# Launch configuration using Custom AMI
resource "aws_launch_template" "terra_lt" {
    image_id      = aws_ami_from_instance.terra_ami.id
    name = "terra_lt"
    instance_type = "t2.micro"
    key_name = "AWS_AMI"

    user_data = "${base64encode(<<EOF
#!/bin/bash
echo "$(hostname -f)" > /var/www/html/ip.txt
EOF
)}"

    network_interfaces {
    	associate_public_ip_address = true
    	security_groups = [aws_security_group.terra_sg.id]
    }

    tags = {
    	Name = "terra_lt"
    }
}
