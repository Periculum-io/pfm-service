variable "alb_listener_routing_host_pfm_api" {
  description = "Host to route request to insights-api target group"
  type = string
}

variable "alb_listener_routing_host_insights_mono_integration_frontend" {
  description = "Host to route request to insights-mono-integration frontend target group"
  type = string
}

variable "alb_listener_routing_host_insights_mono_integration_api" {
  description = "Host to route request to insights-mono-integration-api target group"
  type = string
}

variable "alb_listener_routing_host_insights_dojah_integration_frontend" {
  description = "Host to route request to insights-dojah-integration frontend target group"
  type = string
}

variable "alb_listener_routing_host_insights_dojah_integration_api" {
  description = "Host to route request to insights-dojah-integration-api target group"
  type = string
}

# For consumer platform
variable "alb_listener_routing_host_insights_consumer_api" {
  description = "Host to route request to insights-consumer-api target group"
  type = string
}

variable "alb_listener_routing_host_insights_consumer_frontend" {
  description = "Host to route request to insights-consumer-frontend target group"
  type = string
}