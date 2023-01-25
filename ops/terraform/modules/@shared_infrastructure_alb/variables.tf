variable "vpc_id" {
  description = "The id of the Insights VPC"
  type = string
  default = null
}

variable "alb_name" {
  description = "The name for the ALB"
  type = string
  default = null
}

variable "public_subnet_ids" {
  description = "The public subnet ids to provision the ALB in"
  type = list(string)
  default = null
}

variable "zone_id" {
  description = "The id of the hosted zone"
  type = string
  default = null
}

variable "zone_name" {
  description = "The domain name of the hosted zone"
  type = string
  default = null
}