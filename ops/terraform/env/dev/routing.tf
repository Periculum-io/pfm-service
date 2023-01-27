locals {
  environment = var.environment
  resource_name_prefix = local.environment
  common_tags = {
    environment = local.environment
  }
}

# A valid certificate for given domain must exist in ACM prior creation of the environment
data "aws_acm_certificate" "acm_insights" {
  domain   = var.r53_target_domain
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "acm_insights_mono_integration" {
  domain   = var.r53_target_domain_mono_integration
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "acm_insights_dojah_integration" {
  domain   = var.r53_target_domain_dojah_integration
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "acm_insights_consumer" {
  domain   = var.r53_target_domain_consumer_frontend
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "acm_insights_consumer_backend" {
  domain   = var.r53_target_domain_consumer_backend
  statuses = ["ISSUED"]
}

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
      Name = "${local.resource_name_prefix}-insights-alb-listener"
    },
  )

  depends_on = [module.aws_infrastructure]
}

resource "aws_alb_listener_certificate" "alb_insights_certificate" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_insights.arn
}

resource "aws_alb_listener_certificate" "alb_insights_certificate_mono_integration" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_insights_mono_integration.arn
}

resource "aws_alb_listener_certificate" "alb_insights_certificate_dojah_integration" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_insights_dojah_integration.arn
}

resource "aws_alb_listener_certificate" "alb_insights_certificate_consumer" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_insights_consumer.arn
}

resource "aws_alb_listener_certificate" "alb_insights_certificate_consumer_backend" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  certificate_arn = data.aws_acm_certificate.acm_insights_consumer_backend.arn
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_mono_integration_frontend" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 600

  action {
    type             = "forward"
    target_group_arn = module.insights_mono_integration_frontend.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_mono_integration_frontend]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_dojah_integration_frontend" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 500

  action {
    type             = "forward"
    target_group_arn = module.insights_dojah_integration_frontend.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_dojah_integration_frontend]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = module.insights_api.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_api]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_mono_integration_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = module.insights_mono_integration_api.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_mono_integration_api]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_dojah_integration_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = module.insights_dojah_integration_api.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_dojah_integration_api]
    }
  }
}

# for consumer platform
resource "aws_alb_listener_rule" "alb_listener_rule_insights_consumer_api" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 400

  action {
    type             = "forward"
    target_group_arn = module.insights_consumer_api.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_consumer_api]
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_insights_consumer_frontend" {
  listener_arn = aws_alb_listener.alb_listener_https.arn
  priority     = 700

  action {
    type             = "forward"
    target_group_arn = module.insights_consumer_frontend.target_group_id
  }

  condition {
    host_header {
      values = [var.alb_listener_routing_host_insights_consumer_frontend]
    }
  }
}

