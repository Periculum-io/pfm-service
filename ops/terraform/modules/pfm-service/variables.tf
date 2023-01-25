# Common Variables
variable "application_name" {
  description = "The name of the application for which KeyCloak is being deployed"
  type = string
  default = null
}

variable "github_secret_arn" {
  description = "The secrets manager secret which stores the github username and PSA"
  default = null
  type = string
}

variable "application_short_name" {
  description = "The short application name without the prefix"
  type = string
  default = null
}

variable "aws_region" {
  description = "The region in which all infrastructure will be deployed"
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  description = "The id of the VPC where everything will be hosted"
  type = string
  default = null
}

variable "public_subnet_ids" {
  description = "The ids of the public subnets"
  type = list(string)
  default = null
}

variable "private_subnet_ids" {
  description = "The ids of the private subnets"
  type = list(string)
  default = null
}

# ALB Variables
variable "alb_target_port" {
  description = "The port the ALB should connect to backend services on on"
  type = number
  default = 8080
}

# DNS Variables
variable "public_dns_name" {
  description = "The friendly public name of the address the keycloak service will be available at"
  type = string
  default = null
}

variable "zone_id" {
  description = "The id of the hosted zone"
  type = string
  default = null
}

variable "aws_alb_listener_arn" {
  description = "ARN of the ALB listener"
  type = string
  default = null
}

variable "alb_listener_priority" {
  description = "Priority of the ALB listener"
  type = number
  default = null
}

# EC2 Variables
variable "key_name" {
  description = "The name of the key for the instance"
  type = string
  default = null
}

variable "ec2_instance_type" {
  description = "The RDS instance type"
  type = string
  default     = "t3.micro"
}

variable "alb_security_group_id" {
  description = "The security group id of the ALB"
  default = null
  type = string
}

# RDS Variables
variable "rds_username" {
  description = "The username of the Keycloak RDS instance"
  type = string
  default = "masteruser"
}

variable "database_name" {
  description = "The name of the db"
  type = string
  default = null
}

variable "database_username" {
  description = "The username of the db user"
  type = string
  default = null
}

variable "rds_kms_key_alias_names" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance insights."
  default = [ "rds-key", "performance-insights-key" ]
}

variable "enc_key_deletion_in_days" {
  description = "How often should the encryption key be rotated"
  type = number
  default = 10
}

variable "enc_key_rotation_enabled" {
  description = "How often should the encryption key be rotated"
  type = bool
  default = true
}

variable "rds_storage_gigabytes" {
  description = "The amount of RDS storage to provision, in gigabytes"
  type = number
  default = 50
}

variable "rds_backup_retention_days" {
  description = "RDS backup retention period, in days"
  type = number
  default = 30
}

variable "rds_engine" {
  description = "The RDS engine to use"
  type = string
  default = "postgres"
}

variable "rds_engine_version" {
  description = "The version of the postgrest db engine"
  type = string
  default = "13.4"
}

variable "rds_multi_az" {
  description = "The RDS multi-availability zone flag"
  type = bool
  default = false
}

variable "rds_instance_type" {
  description = "The RDS instance type"
  default     = "db.t2.small"
  type = string
}