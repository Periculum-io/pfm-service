resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = var.api_gateway_resource_path
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = var.api_gateway_http_method
  authorization = var.api_gateway_method_authorization
}

resource "aws_api_gateway_integration" "api_gateway_integration_lambda" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.api_gateway_method.http_method

  integration_http_method = var.api_gateway_integration_method
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_method.api_gateway_method,
    aws_api_gateway_integration.api_gateway_integration_lambda
  ]

  description = "Deployed at ${timestamp()}"
  rest_api_id = var.api_gateway_id
  stage_name  = var.stage_name
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}