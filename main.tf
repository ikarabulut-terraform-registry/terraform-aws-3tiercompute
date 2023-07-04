data "aws_subnet" "public-subnet" {
  filter {
    name   = "cidr-block"
    values = [var.public-subnet-cidr]
  }
}

data "aws_subnet" "private-subnet" {
  filter {
    name   = "cidr-block"
    values = [var.private-subnet-cidr]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "cidr-block"
    values = [var.vpc-cidr]
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "public_bastion" {
  ami           =  data.aws_ami.amzn-linux-2023-ami.id
  instance_type = var.instance-type
  key_name      = var.key-name
  vpc_security_group_ids = [aws_security_group.BastionSG.id]

  subnet_id     = data.aws_subnet.public-subnet.id

  root_block_device {
    delete_on_termination = "true"
  }
}

resource "aws_instance" "private_app_instance" {
  ami           =  data.aws_ami.amzn-linux-2023-ami.id
  instance_type = var.instance-type
  key_name      = var.key-name
  vpc_security_group_ids = [aws_security_group.AppSG.id]

  subnet_id     = data.aws_subnet.private-subnet.id

  root_block_device {
    delete_on_termination = "true"
  }
}

resource "aws_security_group" "BastionSG" {
    name        = "BastionSG"
    description = "Allow ssh"
    vpc_id      = data.aws_vpc.vpc.id
    
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "AppSG" {
    name        = "AppSG"
    description = "Allow ssh"
    vpc_id      = data.aws_vpc.vpc.id
    
    ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "TCP"
        security_groups = [aws_security_group.BastionSG.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}