locals {
  environment = var.environment
  resource_name_prefix = var.resource_name_prefix
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
    "Application" = "PFM"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "acm_pfm_frontend" {
  domain_name       = var.r53_target_domain_pfm_admin_frontend
  validation_method = "DNS"

  tags = {
    "Application" = "PFM"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "acm_pfm_flask_api" {
  domain_name       = var.r53_target_domain_pfm_flask_api
  validation_method = "DNS"

  tags = {
    "Application" = "PFM"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn   = module.aws_infrastructure.alb_id
  port                = "443"
  protocol            = "HTTPS"
  certificate_arn     = aws_acm_certificate.acm_pfm_frontend.arn

  # If URL does not match any rule, it is currently being forwarded to UI
  default_action {
    type = "forward"
    target_group_arn = module.frontend.target_group_id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}-pfm-alb-listener"
    },
  )

  depends_on = [module.aws_infrastructure]
}

# resource "aws_alb_listener_certificate" "alb_pfm_admin_frontend_certificate" {
#   listener_arn    = aws_alb_listener.alb_listener_https.arn
#   certificate_arn = aws_acm_certificate.acm_pfm_frontend.arn
# }

resource "aws_alb_listener_certificate" "alb_pfm_api_certificate" {
  listener_arn    = aws_alb_listener.alb_listener_https.arn
  certificate_arn = aws_acm_certificate.acm_pfm_admin_api.arn

  depends_on = [
    aws_alb_listener.alb_listener_https
  ]
}

resource "aws_alb_listener_certificate" "alb_pfm_flask_api_certificate" {
  listener_arn    = aws_alb_listener.alb_listener_https.arn
  certificate_arn = aws_acm_certificate.acm_pfm_flask_api.arn

  depends_on = [
    aws_alb_listener.alb_listener_https
  ]
}

resource "aws_lb_target_group" "ec2_load_balancer_target_group" {
  name      = "${local.environment}-${local.resource_name_prefix}-ec2-tg"
  port      = 80
  protocol  = "HTTP"

  vpc_id    = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_load_balancer_ec2_api_instance_attachment" {
  target_group_arn  = aws_lb_target_group.ec2_load_balancer_target_group.arn
  target_id         = module.pfm_flask_api.ec2_instance_id
  port              = 80
}

resource "aws_alb_listener_rule" "alb_listener_rule_pfm_admin_api" { 
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 100

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

resource "aws_alb_listener_rule" "alb_listener_rule_pfm_flask_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_load_balancer_target_group.arn
  }

  condition {
    host_header {
      values = [var.r53_target_domain_pfm_flask_api]
    }
  }
}

# for pfm platform
resource "aws_alb_listener_rule" "alb_listener_rule_pfm_frontend" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 300

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
