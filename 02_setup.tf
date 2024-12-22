provider "aws" {
    region = "eu-north-1"
}

resource "aws_vpc" "Project-TF" {
    cidr_block = "10.0.0.0/16"
    
    enable_dns_support   = true
    enable_dns_hostnames = true
}

resource "aws_subnet" "Project-Subnet" {
    vpc_id     = aws_vpc.Project-TF.id
    cidr_block = "10.0.1.0/24"
    
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.Project-TF.id
}

resource "aws_security_group" "web_sg" {
    vpc_id = aws_vpc.Project-TF.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "TF" {
    instance_type          = "t3.micro"
    ami                    = "ami-07c8c1b18ca66bb07"
    subnet_id              = aws_subnet.Project-Subnet.id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    key_name               = "Trial"
    associate_public_ip_address = true

    tags = {
        Name = "Terraform Web Server"
    }
}

output "instance_ip" {
    value = aws_instance.TF.public_ip
}

output "instance_dns" {
    value = aws_instance.TF.public_dns
}
