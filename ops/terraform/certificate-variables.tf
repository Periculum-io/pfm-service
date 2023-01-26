variable "ec2_lb_hosted_zone_domain" {
  description = "The domain of the hosted zone for this project"
  type = string
  default = null
}

variable "ec2_lb_domain_name" {
  description = "The full domain name of where the solution will be hosted"
  type = string
  default = null
}