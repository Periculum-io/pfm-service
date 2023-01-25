variable "frontend_cpu_units" {
  type = number
  description = "CPU Units to allocate to task definition."
}

variable "frontend_base_url" {
  type = string
  description = "Base URL to API."
}

variable "frontend_ram_units" {
  type = number
  description = "RAM units to allocate to task definition."
}

variable "frontend_ecr_url" {
  description = "Image to be deployed in frontend task"
  type = string
}

variable "frontend_version" {
  description = "Tag which specifies version of the image"
  type = string
}

variable "frontend_task_count" {
  description = "How many frontend tasks/instances will run in ECS cluster"
  type = number
}

variable "frontend_container_port" {
  type = number
  default = 80
}

variable "frontend_container_host_port" {
  type = number
  default = 80
}