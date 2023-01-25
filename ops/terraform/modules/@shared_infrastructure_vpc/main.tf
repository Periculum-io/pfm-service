data "aws_vpc" "insights_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "public_subnets" {
  filter {
    name    = "subnet-id"
    values  = var.public_subnet_ids
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name    = "subnet-id"
    values  = var.private_subnet_ids
  }
}

data "aws_subnet" "public_subnet_1" {
  id  = var.public_subnet_ids[0]
}

data "aws_subnet" "public_subnet_2" {
  id  = var.public_subnet_ids[1]
}

data "aws_subnet" "private_subnet_1" {
  id = var.private_subnet_ids[0]
}

data "aws_subnet" "private_subnet_2" {
  id = var.private_subnet_ids[1]
}