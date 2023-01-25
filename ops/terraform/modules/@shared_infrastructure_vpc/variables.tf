variable "vpc_id" {
  description = "The id of the VPC to host all the infrastructure"
  type = string
  default = null
}

variable "public_subnet_ids" {
  description = "List of public subnets"
  type = list(string)
  default = null
}

variable "private_subnet_ids" {
  description = "List of private subnets"
  type = list(string)
  default = null
}