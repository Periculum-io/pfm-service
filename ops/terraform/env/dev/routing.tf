locals {
  environment = var.environment
  resource_name_prefix = local.environment
  common_tags = {
    environment = local.environment
  }
  certificate_domain_names = [
    var.r53_target_domain_pfm_admin_api,
    var.r53_target_domain_pfm_admin_frontend
  ]
}

resource "aws_acm_certificate" "acm_pfm_admin_api" {
  domain_name       = var.r53_target_domain_pfm_admin_api
  validation_method = "DNS"

  tags = {
    "Application" = "Insights"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "acm_pfm_frontend" {
  domain_name       = var.r53_target_domain_pfm_admin_frontend
  validation_method = "DNS"

  tags = {
    "Application" = "Insights"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# A valid certificate for given domain must exist in ACM prior creation of the environment
# data "aws_acm_certificate" "acm_pfm_admin_api" {
#   domain   = var.r53_target_domain_pfm_admin_api
#   statuses = ["ISSUED"]
# }

# data "aws_acm_certificate" "acm_pfm_frontend" {
#   domain   = var.r53_target_domain_pfm_admin_frontend
#   statuses = ["ISSUED"]
# }

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn   = module.aws_infrastructure.alb_id
  port                = "443"
  protocol            = "HTTPS"

  # If URL does not match any rule, it is currently being forwarded to UI
  default_action {
    type = "forward"
    target_group_arn = module.frontend.target_group_id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-pfm-alb-listener"
    },
  )

  depends_on = [module.aws_infrastructure]
}

resource "aws_alb_listener_certificate" "alb_pfm_admin_frontend_certificate" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = aws_acm_certificate.acm_pfm_frontend.arn
}

resource "aws_alb_listener_certificate" "alb_pfm_api_certificate" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = aws_acm_certificate.acm_pfm_admin_api.arn
} 

# for pfm platform
resource "aws_alb_listener_rule" "alb_listener_rule_pfm_admin" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = module.frontend.target_group_id
  }

  condition {
    host_header {
      values = [var.r53_target_domain_pfm_admin_frontend]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_pfm_admin_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = module.pfm_admin_api.target_group_id
  }

  condition {
    host_header {
      values = [var.r53_target_domain_pfm_admin_api]
    }
  }
}

