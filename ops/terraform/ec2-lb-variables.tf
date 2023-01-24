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