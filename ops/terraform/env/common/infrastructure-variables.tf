variable "vpc_id" {
  description = "The id of the vpc where all things for this project will be hosted in"
  default     = null
  type        = string
}

variable "vpc_pfm_private_subnets" {
  type = list(string)
}

variable "vpc_pfm_public_subnets" {
  type = list(string)
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type = string
}

variable "ecs_cluster_capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster."
  type = list(string)
}

variable "ecs_container_insights_enabled" {
  description = "Indicates if advanced monitoring (container insights) should be enabled on ECS cluster"
  type = string
}

variable "vpc_public_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for public subnets"
}

variable "vpc_private_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for private subnets"
}

variable "alb_log_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured"
  type = string
}

variable "alb_log_enabled" {
  description = "Boolean to enable / disable access_logs"
  type = bool
}

variable "alb_s3_bucket_acl" {
  description = "ACL type"
  type = string
}

variable "r53_hosted_zone_id" {
  type = string
  description = "ID of the zone that will be manipulated"
}

variable "r53_hosted_zone_name" {
  type = string
  description = "Name of the zone that will be manipulated"
}

variable "r53_target_domain_pfm_admin_api" {
  type = string
  description = "Domain where the pfm admin api application shall be exposed to"
}

variable "r53_target_domain_pfm_admin_frontend" {
  type = string
  description = "Domain where the pfm admin ui application shall be exposed to"
}

variable "r53_target_domain_pfm_flask_api" {
  type = string
  description = "Domain where the flask api application shall be exposed to"
}

variable "alb_s3_bucket_id" {
  description = "VPC ID for the environment"
  type = string
}