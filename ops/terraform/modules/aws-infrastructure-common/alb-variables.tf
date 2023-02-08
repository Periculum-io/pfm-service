variable "alb_log_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured"
  type = string
  default = "alb"
}

variable "alb_log_enabled" {
  description = "Boolean to enable / disable access_logs"
  type = bool
  default = true
}

variable "alb_s3_bucket_acl" {
  description = "ACL type"
  type = string
  default = "private"
}

variable "vpc_id" {
  description = "VPC ID for the environment"
  type = string
}

variable "vpc_pfm_private_subnets" {
  description = "The private subnets for the VPC"
  type = list(string)
}
variable "alb_s3_bucket_id" {
  description = "VPC ID for the environment"
  type = string
}