data "aws_route53_zone" "r53_zone_insights" {
  zone_id = var.r53_hosted_zone_id
}

resource "aws_route53_record" "r53_record_a_domain" {
  zone_id = data.aws_route53_zone.r53_zone_insights.zone_id
  name    = var.r53_target_domain
  type    = "A"

  alias {
    name                   = aws_alb.alb_insights.dns_name
    zone_id                = aws_alb.alb_insights.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "r53_record_a_domain_mono_integration" {
  zone_id = data.aws_route53_zone.r53_zone_insights.zone_id
  name    = var.r53_target_domain_mono_integration
  type    = "A"

  alias {
    name                   = aws_alb.alb_insights.dns_name
    zone_id                = aws_alb.alb_insights.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "r53_record_a_domain_dojah_integration" {
  zone_id = data.aws_route53_zone.r53_zone_insights.zone_id
  name    = var.r53_target_domain_dojah_integration
  type    = "A"

  alias {
    name                   = aws_alb.alb_insights.dns_name
    zone_id                = aws_alb.alb_insights.zone_id
    evaluate_target_health = true
  }
}