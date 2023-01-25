resource "aws_security_group" "instance_sg" {
  description = "The security group allowing SSH administrative access to the instances"
  vpc_id      = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    security_groups = [
      var.alb_security_group_id,
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "genkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.key_name
  public_key = tls_private_key.genkey.public_key_openssh
}

resource "aws_instance" "keycloak_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ssh-key.key_name

  user_data     = base64encode(templatefile("${path.module}/templates/init.sh", local.ec2_user_data_variables))
  
  subnet_id     = var.public_subnet_ids[0]

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = {
    Name = "${var.application_name}-ec2-instance-1"
  }
}