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

variable "resource_name_prefix" {
  description = "Name of the resouce name prefix"
  type = string
}