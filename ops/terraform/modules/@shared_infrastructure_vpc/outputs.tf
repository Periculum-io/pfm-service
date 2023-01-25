output "vpc_id" {
  value = data.aws_vpc.insights_vpc.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids
}

output "private_subnet_ids" {
  value = data.aws_subnets.private_subnets.ids
}

output "public_subnet_1_id" {
  value = data.aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = data.aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  value = data.aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = data.aws_subnet.private_subnet_2.id
}

output "private_subnet_1_cidr_block" {
  value = data.aws_subnet.private_subnet_1.cidr_block
}

output "private_subnet_2_cidr_block" {
  value = data.aws_subnet.private_subnet_2.cidr_block
}