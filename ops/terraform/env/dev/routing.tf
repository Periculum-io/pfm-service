locals {
  environment = var.environment
  resource_name_prefix = local.environment
  common_tags = {
    environment = local.environment
  }
}

# A valid certificate for given domain must exist in ACM prior creation of the environment
data "aws_acm_certificate" "acm_pfm_admin_api" {
  domain   = var.r53_target_domain_pfm_admin_api
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "acm_pfm_frontend" {
  domain   = var.r53_target_domain_pfm_admin_frontend
  statuses = ["ISSUED"]
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn   = module.aws_infrastructure.alb_id
  port                = "443"
  protocol            = "HTTPS"

  # If URL does not match any rule, it is currently being forwarded to UI
  default_action {
    type = "forward"
    target_group_arn = module.pfm-service.target_group_id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-alb-listener"
    },
  )

  depends_on = [module.aws_infrastructure]
}

resource "aws_alb_listener_certificate" "alb_pfm_admin_certificate" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_pfm_admin_api.arn
}

resource "aws_alb_listener_certificate" "alb_pfm_api_certificate" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_pfm_frontend.arn
} 

# for pfm platform
resource "aws_alb_listener_rule" "alb_listener_rule_pfm_admin" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = module.pfm-service.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_pfm_admin]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_pfm_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = module.insights_consumer_frontend.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_pfm_api]
    }
  }
}

