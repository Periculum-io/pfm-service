variable "aws_region" {
  description = "Region in which AWS resources will be created"
  type = string
}

variable "environment" {
  description = "Name of the environment"
  type = string
}

variable "vpc_id" {
  description = "The id of the vpc where all things for this project will be hosted in"
  default     = null
  type        = string
}

variable "resource_name_prefix" {
  description = "Name of the resouce name prefix"
  type = string
}