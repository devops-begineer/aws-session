variable "vpc_cidr" {
 default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
 default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
 default = "10.0.2.0/24"
}

variable "region" {
 default = "us-east-1"
}

variable "instance_ami" {
 default = "ami-0b72821e2f351e396" 
}

variable "instance_type" {
 default = "t2.micro"
}

variable "key_name" {
 default = "key-pair"
}
