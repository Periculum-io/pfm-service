variable "environment" {
  description = "Name of the environment"
  type = string
}

variable "aws_region" {
  description = "Name of the region"
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "source_security_groups" {
  type = list(string)
  description = "List of SG IDs that should be allowed to interact with API Gateway."
}