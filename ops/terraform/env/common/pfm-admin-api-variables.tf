variable "pfm_admin_api_cpu_units" {
  type = number
  description = "CPU Units to allocate to task definition."
}

variable "pfm_admin_api_ram_units" {
  type = number
  description = "RAM units to allocate to task definition."
}

variable "pfm_admin_api_ecr_url" {
  description = "Image to be deployed in pfm_admin_api task"
  type = string
}

variable "pfm_admin_api_version" {
  description = "Tag which specifies version of the image"
  type = string
}

variable "pfm_admin_api_task_count" {
  description = "How many insights-api tasks/instances will run in ECS cluster"
  type = number
}

variable "pfm_admin_api_container_port" {
  type = number
}

variable "pfm_admin_api_container_host_port" {
  type = number
}

variable "pfm_admin_api_secret_manager_arn" {
  type = string
}

variable "pfm_admin_api_sensitive_secret_arn" {
  type = string
}

variable "pfm_admin_api_allowed_cors_origin" {
  type = string
}

variable "pfm_admin_api_auth0_domain" {
  type = string
}

variable "pfm_admin_api_auth0_audience" {
  type = string
}