variable "aws_region" {
  description = "Region in which AWS resources will be created"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Name of the environment"
  type = string
  default = "test"
}