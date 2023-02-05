data "aws_route53_zone" "r53_zone_pfm_hosted_zone" {
  zone_id = var.r53_hosted_zone_id
}

resource "aws_route53_record" "r53_record_a_domain_pfm" {
  zone_id = data.aws_route53_zone.r53_zone_pfm_hosted_zone.zone_id
  name    = var.r53_target_domain_pfm_admin_frontend
  type    = "A"

  alias {
    name                   = aws_alb.alb_pfm.dns_name
    zone_id                = aws_alb.alb_pfm.zone_id
    evaluate_target_health = true
  }
}
