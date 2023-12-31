variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "public-subnet-id" {
  description = "Public subnet id for the public instance"
  type        = string
}

variable "private-subnet-id" {
  description = "Private subnet id for the private app instance"
  type        = string
}

variable "instance-type" {
  description = "Instance type for EC2"
  type = string
  default = "t2.micro"
}

variable "key-name" {
  description = "Key name for the key pair"
  type = string
}

variable "bastion-sg-id" {
  description = "Key name for the key pair"
  type = string
}

variable "app-sg-id" {
  description = "Key name for the key pair"
  type = string
}