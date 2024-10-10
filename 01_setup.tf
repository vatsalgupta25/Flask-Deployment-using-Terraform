# provider "aws" {
#     region = "eu-north-1"
# }

# resource "aws_vpc" "Project-TF" {
#     cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "Project-Subnet" {
#     vpc_id = aws_vpc.Project-TF.id
#     cidr_block = "10.0.1.0/24"
#     map_public_ip_on_launch = true
# }

# resource "aws_internet_gateway" "igw"{
#     vpc_id = aws_vpc.Project-TF.id
# }

# data "aws_security_group" "lowsecurity" {
#     filter {
#         name   = "group-name"
#         values = ["lowsecurity"]
#     }
# }

# resource "aws_instance" "TF" {
#     instance_type          = "t3.micro"
#     ami                    = "ami-07c8c1b18ca66bb07"
#     subnet_id              = aws_subnet.Project-Subnet.id
#     vpc_security_group_ids = [data.aws_security_group.lowsecurity.id]
#     key_name               = "Trial"
#     associate_public_ip_address = true

#     tags = {
#         Name = "Terraform Web Server"
#     }
# }

# output "instance_ip" {
#   value = aws_instance.TF.public_ip
# }