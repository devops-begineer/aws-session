provider "aws" {
 region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
 cidr_block           = var.vpc_cidr
 enable_dns_support   = true
 enable_dns_hostnames = true
 tags = {
   Name = "main-vpc"
 }
}

# Create Subnets
resource "aws_subnet" "public" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = var.public_subnet_cidr
 map_public_ip_on_launch = true
 tags = {
   Name = "public-subnet"
 }
}

resource "aws_subnet" "private" {
 vpc_id     =
aws_vpc.main.id
 cidr_block = var.private_subnet_cidr
 tags = {
   Name = "private-subnet"
 }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id

 tags = {
   Name = "main-igw"
 }
}

# Create Route Tables
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

resource "aws_route_table_association" "public" {
 subnet_id      = aws_subnet.public.id
 route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat" {
 allocation_id = aws_eip.nat.id
 subnet_id     = aws_subnet.public.id

 tags = {
   Name = "main-nat"
 }
}

resource "aws_eip" "nat" {
 vpc = true
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
# Create Security Groups
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
 tags = {
   Name = "lb-sg"
 }
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
 tags = {
   Name = "instance-sg"
 }
}

# Create Launch Configuration
resource "aws_launch_configuration" "web" {
 name          = "web-lc"
 image_id      = var.instance_ami
 instance_type = var.instance_type
 security_groups = [aws_security_group.instance_sg.id]
 key_name      = var.key_name
 user_data = <<-EOF
             #!/bin/bash
             yum update -y
             yum install -y httpd
             systemctl start httpd
             systemctl enable httpd
             echo "<html><body><h1>Hello, World!</h1></body></html>" > /var/www/html/index.html
             EOF
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "web" {
 desired_capacity     = 3
 max_size             = 3
 min_size             = 1
 vpc_zone_identifier  = [
aws_subnet.public.id
]
 launch_configuration =
aws_launch_configuration.web.id

 tag {
   key                 = "Name"
   value               = "web-instance"
   propagate_at_launch = true
 }
}

# Create Load Balancer
resource "aws_lb" "web" {
 name               = "web-lb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.lb_sg.id]
 subnets            = [
aws_subnet.public.id
]
 tags = {
   Name = "web-lb"
 }
}

resource "aws_lb_target_group" "web" {
 name     = "web-tg"
 port     = 80
 protocol = "HTTP"
 vpc_id   =
aws_vpc.main.id

 health_check {
   path                = "/"
   interval            = 30
   timeout             = 5
   healthy_threshold   = 2
   unhealthy_threshold = 2
   matcher             = "200"
 }
}

resource "aws_lb_listener" "web" {
 load_balancer_arn = aws_lb.web.arn
 port              = "80"
 protocol          = "HTTP"
 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.web.arn
 }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
 autoscaling_group_name = aws_autoscaling_group.web.name
 alb_target_group_arn   = aws_lb_target_group.web.arn
}
