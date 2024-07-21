# AWS Scalable Web Application Deployment with Terraform

This project demonstrates how to use Terraform to deploy a scalable and highly available web application on AWS. It outlines creating a robust architecture involving a VPC, subnets, an internet gateway, a NAT gateway, security groups, an application load balancer, EC2 instances, and an auto-scaling group.

## Project Overview

The configuration sets up the following AWS resources to ensure a secure, scalable, and fault-tolerant web application environment:

### 1. Virtual Private Cloud (VPC)

**Purpose**: Creates an isolated network environment within AWS where you can launch AWS resources in a virtual network that you define.
- **Why**: This is essential to control the network environment, including the selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways.

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}
```
### 2. Subnets

**Purpose**: Segregates resources into different blocks within the VPC to streamline management and security.
**Public Subnets**: Used for resources that need to be accessible from the internet.
**Private Subnet**: Used for resources that should not be directly accessible from the internet.

```hcl
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = { Name = "public-subnet-2" }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = { Name = "private-subnet" }
}
```

### 3. Internet Gateway

**Purpose**: Provides a gateway for resources in the public subnets to access the internet and vice versa.
- **Why**: This is critical for internet-facing resources to serve traffic and for backend systems to fetch updates and patches.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}
```

### 4. NAT Gateway

**Purpose**: Enables instances in the private subnet to access the internet for updates and patches while keeping them not directly reachable from the internet.
- **Why**: is enhances the security of backend systems by reducing their exposure to external threats.

```hcl
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = { Name = "main-nat" }
}
```

### 5. Route Tables

**Purpose**: Defines rules, known as routes, that determine where network traffic from subnets and gateways is directed.
**Public Route Table**: Routes traffic from the public subnets to the internet via the IGW.
**Private Route Table**: Routes traffic from the private subnet to the internet via the NAT Gateway.

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
```

### 6. Security Groups

**Purpose**: Controls inbound and outbound traffic to EC2 instances and other resources.
**Why**: Essential for enforcing security policies by restricting access to resources based on IP, protocol, and ports.

```hcl
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "lb-sg" }
}

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.lb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "instance-sg" }
}
```

