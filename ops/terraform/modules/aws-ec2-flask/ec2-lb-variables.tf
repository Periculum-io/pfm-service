variable "ec2_lb_log_prefix" {
  description = "The prefix for logs output by the network load balancer"
  default     = null
  type        = string
}

variable "ec2_lb_log_enabled" {
  description = "If logs for the network load balancer are enabled"
  default     = true
  type        = bool
}

variable "ec2_lb_domain_name" {
  description = "The flask server domain"
  type        = string
}

variable "ec2_lb_hosted_zone_domain" {
  description = "The EC2 hosted domain zone"
  type        = string
}

