locals {
    secret_string = {
         
    }
}
data "aws_vpc" "insights_vpc" {
  id = var.vpc_id
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

data "aws_subnets" "pfm_public_subnets" {
  filter {
    name    = "subnet-id"
    values  = var.vpc_pfm_public_subnets
  }
}

data "aws_subnet" "pfm_public_subnet" {
  for_each  = toset(data.aws_subnets.pfm_public_subnets.ids)
  id        = each.value
}

data "aws_subnet" "insights_private_subnet_us_east_1a" {
  id = var.ec2_prod_insights_private_subnet_us_east_1a
}

data "aws_elb_service_account" "elb_service_account_insights" {
}

# data "aws_secretsmanager_secret" "sm_init" {
#   name = var.sm_init
# }

# data "aws_secretsmanager_secret_version" "sm_init_current" {
#   secret_id = data.aws_secretsmanager_secret.sm_init.id
# }

resource "aws_secretsmanager_secret" "sm_init_ec2_key" {
  name = var.ec2_ssh_private_key_secret_name
}

resource "aws_secretsmanager_secret_version" "sm_init_ec2_key_current" {
  secret_id = aws_secretsmanager_secret.sm_init_ec2_key.id
}

resource "aws_secretsmanager_secret" "sm_init_ec2_key_pub" {
  name = var.ec2_ssh_public_key_secret_name
}

resource "aws_secretsmanager_secret_version" "sm_init_ec2_key_pub_current" {
  secret_id = aws_secretsmanager_secret.sm_init_ec2_key_pub.id
  secret_string = jsonencode(local.secret_string)
}

resource "aws_security_group" "security_group_ec2" {
  name              = "${local.resource_name_prefix}-ec2-security-group"
  description       = "SG for ec2 instance that hosts pfm flask api"
  vpc_id            = var.vpc_id

  tags = {
    Name = "${local.resource_name_prefix}-ec2-security-group"
  }
}

# Allow ingress from HTTP port
resource "aws_security_group_rule" "security_group_rule_ec2_http_ingress" {
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_ec2.id
  source_security_group_id  = aws_security_group.security_group_pfm_alb.id
}


# Allow any ingress to EC2 via SSH
resource "aws_security_group_rule" "security_group_rule_ec2_ssh_ingress" {
  type                      = "ingress"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_ec2.id
  cidr_blocks               = ["0.0.0.0/0"]
}

# Allow connectivity from EC2 to RDS
resource "aws_security_group_rule" "security_group_rule_ec2_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group_ec2.id
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "${local.resource_name_prefix}-ec2-ssh-key"
  public_key = aws_secretsmanager_secret_version.sm_init_ec2_key_pub_current.secret_string
}

resource "aws_instance" "pfm_api_instance_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ssh-key.key_name

  user_data     = base64encode(templatefile("init.sh", local.template_file_vars))
  
  subnet_id     = local.public_subnet_ids[0]

  vpc_security_group_ids = [aws_security_group.security_group_ec2.id]

  tags = {
    Name = "${local.resource_name_prefix}-ec2-instance-1"
  }
}

output "instance_1_host_address" {
  value = aws_instance.pfm_api_instance_1.public_dns
}

output "github_username" {
  value = local.github_info.username
  sensitive = true
}

output "github_personal_access_token" {
  value = local.github_info.personal_access_token
  sensitive = true
}