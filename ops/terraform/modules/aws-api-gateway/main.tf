resource "aws_security_group" "security_group_vpc_endpoint" {
  name              = "${local.resource_name_prefix}-vpc-endpoint-security-group"
  description       = "Defines traffic restrictions to/from API Gateway."
  vpc_id            = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-vpc-endpoint-security-group"
    },
  )
}

resource "aws_security_group_rule" "security_group_rule_pdf_processor" {
  count                     = length(var.source_security_groups)
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = 443
  to_port                   = 443
  security_group_id         = aws_security_group.security_group_vpc_endpoint.id
  source_security_group_id  = var.source_security_groups[count.index]
}

resource "aws_vpc_endpoint" "vpc_endpoint_api_gateway" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.execute-api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [aws_security_group.security_group_vpc_endpoint.id]
  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-api-gateway"
    },
  )
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "${local.resource_name_prefix}-insights"

  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.vpc_endpoint_api_gateway.id]
  }
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_rest_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*",
      "Condition": {
          "StringNotEquals": {
              "aws:SourceVpce": "${aws_vpc_endpoint.vpc_endpoint_api_gateway.id}"
          }
      }
    }
  ]
}
EOF
}