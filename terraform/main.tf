terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

# variable "AWS_REGION" {}
# variable "PROFILE" {}
provider "aws" {
    region = "us-east-1" //var.AWS_REGION 
    profile = "lara-private"// var.PROFILE 
}

# Create an AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/24"

   tags = {
    Name = "eval-4-vpc",
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "eval-4-igw",
  }
}

# Create a subnet 
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.64/26"
  
  tags = {
    Name = "eval-4-subnet",
  }
}

# Create a public route table routing 0.0.0.0/0 to the internet gateway
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "eval-4-public-subnet",
  }
}

# Associate the public subnet to the public route table
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

# Create security group
resource "aws_security_group" "subnet-sg" {
  name = "eval-4-subnet-sg"
  description = "Allow all incoming traffic 0.0.0.0/0 (public internet)"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "all traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "eval-4-subnet-sg",
  }
}

# Ec2 instance
resource "aws_instance" "instance" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name = "lara-us-east-1" // replace with your own 
  vpc_security_group_ids = [aws_security_group.subnet-sg.id]
  subnet_id = aws_subnet.subnet.id
  associate_public_ip_address = true
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y ca-certificates curl gnupg
                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg

                # Add the repository to Apt sources:
                echo \
                    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                
                # Install Docker Engine
                sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin     docker-compose-plugin
                echo "Docker installed"
                sudo docker pull laratunc/nodeapp
                echo "Docker image pulled"

                # Install docker-compose
                sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                echo "Docker-compose installed" 

                # Create docker-compose.yml file 
                cat <<DOCKER_COMPOSE > docker-compose.yml
              version: '3.7'

              services:
                node:
                  container_name: nodeapp
                  image: laratunc/nodeapp
                  ports:
                    - "3000:3000"
                  networks:
                    - nodeapp-network
                  volumes:
                    - ./logs:/var/www/logs
                  environment:
                    - NODE_ENV=production
                    - APP_VERSION=1.0
                  depends_on:
                    - mongodb

                mongodb:
                  container_name: mongodb
                  image: mongo
                  networks:
                    - nodeapp-network

              networks:
                nodeapp-network:
                  driver: bridge
              DOCKER_COMPOSE

                # Run docker-compose
                sudo docker-compose up -d
              EOF

  tags = {
    Name = "eval-4-instance",
  }
}
