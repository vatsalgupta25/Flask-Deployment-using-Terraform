provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "vpc" {
  id = "vpc-09d4c295b6eedf2ed"
}

data "aws_subnet" "subnet" {
  id = "subnet-07c169a50fc06f7c5"
}

data "aws_security_group" "sg" {
  id = "sg-046ec9eb4fd458c86"
}

resource "aws_instance" "second" {
  instance_type           = "t3.micro"
  ami                    = "ami-075449515af5df0d1"
  key_name               = "Trial"
  subnet_id              = data.aws_subnet.subnet.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.my_instance_profile.name

  user_data = <<-EOF
  #!/bin/bash
  set -e

  # Update packages and install necessary tools
  sudo apt-get update -y
  sudo apt-get install -y snapd python3-pip

  # Install AWS CLI using Snap
  sudo snap install aws-cli --classic

  # Create a directory for the app and copy files from S3
  mkdir -p /home/ubuntu/app
  aws s3 cp s3://firstawsbucketdd/ /home/ubuntu/app/ --recursive

  # Navigate to the app directory and install Python dependencies
  cd /home/ubuntu/app
  sudo apt-get install -y python3-flask
  sleep 5  # Add a brief pause to ensure Flask is installed

  # Run the Python script
  sudo python3 te.py
  EOF

  tags = {
    Name = "SimpleInstance"
  }

  depends_on = [aws_iam_instance_profile.my_instance_profile]
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_s3_access_role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF

  tags = {
    Name = "EC2S3AccessRole"
  }
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "ec2_s3_access"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "EC2InstanceProfile"
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.second.id

  tags = {
    Name = "SimpleInstanceEIP"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.second.id
  allocation_id = aws_eip.ip.id
}

output "ip" {
  value = aws_eip.ip.public_ip
}
