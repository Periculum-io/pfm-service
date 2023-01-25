output "vpc_endpoint_security_group_id" {
  value = aws_security_group.security_group_vpc_endpoint.id
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}

output "api_gateway_root_resource_id" {
  value = aws_api_gateway_rest_api.api_gateway.root_resource_id
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.api_gateway.execution_arn
}