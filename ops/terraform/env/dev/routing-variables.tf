variable "alb_listener_routing_host_pfm_admin" {
  description = "Host to route request to pfm-admin ui target group"
  type = string
}

variable "alb_listener_routing_host_pfm_api" {
  description = "Host to route request to pfm admin api target group"
  type = string
}