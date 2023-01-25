resource "aws_acm_certificate" "main" {
  domain_name = var.public_dns_name
  validation_method = "DNS"

  tags = {
    "Application" = "Pfm"
  }
}

resource "aws_route53_record" "certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_record : record.fqdn]
}

resource "aws_lb_listener_certificate" "main" {
  listener_arn    = var.aws_alb_listener_arn
  certificate_arn = aws_acm_certificate.main.arn
}

resource "aws_alb_listener_rule" "alb_listener_rule_keycloak" {
  listener_arn = var.aws_alb_listener_arn
  priority     = var.alb_listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.keycloak_alb_target_group.id
  }

  condition {
    host_header {
      values = [ var.public_dns_name ]
    }
  }
}