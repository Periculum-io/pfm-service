variable "service_name" {
  description = "Name of the service that will be instantiated by this module"
  type = string
}

variable "resource_name_prefix" {
  description = "Resouce name prefix of service"
  type = string
}

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

variable "aws_cloudwatch_logs_group" {
  type = string
}

variable "task_cpu_units" {
  type = number
  description = "CPU Units to allocate to task definition."
  default = 1
}

variable "task_ram_units" {
  type = number
  description = "RAM units to allocate to task definition."
  default = 512
}

variable "task_secrets_enabled" {
  type = bool
  default = false
}

variable "task_secrets" {
  type = list(object({ name=string, valueFrom=string }))
  default = null
}

variable "task_environment_variables" {
  type = list(object({ name=string, value=string }))
  default = null
}

variable "secrets_manager_arn" {
  type = string
  default = ""
}

variable "sensitive_secrets_arn" {
  type = string
  default = ""
}

variable "container_image" {
  description = "Image to be deployed in task"
  type = string
}

variable "container_tag" {
  type = string
  description = "Tag which specifies version of the image"
  default = "latest"
}

variable "container_port" {
  type = number
  default = 80
}

variable "container_host_port" {
  type = number
  default = 80
}

variable "ecs_cluster_id" {
  type = string
  description = "ID of the ECS cluster the task will be deployed in"
}

variable "ecs_service_task_count" {
  type = number
  description = "How many frontend tasks will run in ECS cluster"
  default = 1
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_logs_bucket_id" {
  type = string
  description = "ID of the s3 bucket where to put logs from internal ALB"
}

variable "alb_logs_prefix" {
  type = string
  description = "Which prefix should internal ALB put logs into"
}

variable "alb_logs_enabled" {
  type = bool
  default = false
}

variable "security_group_alb_from_port" {
  type = number
  description = "Which port the internal frontend ALB is allowed to accept traffic from"
}

variable "security_group_alb_to_port" {
  type = number
  description = "Which port the internal frontend ALB is allowed to send traffic to"
}

variable "source_security_group_alb_id" {
  type = string
  description = "Security group from which the internal frontend ALB is allowed to accept traffic"
}