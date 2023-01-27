variable "api_gateway_id" {
  type = string
}

variable "api_gateway_root_resource_id" {
  type = string
}

variable "api_gateway_resource_path" {
  type = string
}

variable "api_gateway_http_method" {
  type = string
  default = "ANY"
}

variable "api_gateway_integration_method" {
  type = string
  default = "ANY"
}

variable "api_gateway_method_authorization" {
  type = string
  default = "NONE"
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "lambda_function_invoke_arn" {
  type = string
}

variable "stage_name" {
  type = string
  default = "live"
}