variable "ec2_dev_insights_private_subnets_us_east_1" {
  description = "The private subnets to launch all ec2 instances in"
  default     = null
  type        = list(string)
}