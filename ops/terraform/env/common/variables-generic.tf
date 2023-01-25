variable "aws_region" {
  description = "Region in which AWS resources will be created"
  type = string
}

variable "availability_zones" {
  type = list(string)
  description = "List of availability zones"
}

variable "environment" {
  description = "Name of the environment"
  type = string
}