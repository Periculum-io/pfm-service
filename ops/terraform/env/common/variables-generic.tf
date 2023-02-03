variable "aws_region" {
  description = "Region in which AWS resources will be created"
  type = string
}

variable "environment" {
  description = "Name of the environment"
  type = string
}

variable "resource_name_prefix" {
  description = "Name of the resouce name prefix"
  type = string
}