data "aws_route53_zone" "r53_zone_pfm_hosted_zone" {
  zone_id = var.r53_hosted_zone_id
}

resource "aws_route53_record" "r53_record_a_domain_pfm_admin_api" {
  zone_id = data.aws_route53_zone.r53_zone_pfm_hosted_zone.zone_id
  name    = var.r53_target_domain_pfm_admin_api
  type    = "A"

  alias {
    name                   = var.r53_hosted_zone_name
    zone_id                = var.r53_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "r53_record_a_domain_pfm_admin_frontend" {
  zone_id = data.aws_route53_zone.r53_zone_pfm_hosted_zone.zone_id
  name    = var.r53_target_domain_pfm_admin_frontend
  type    = "A"

  alias {
    name                   = var.r53_hosted_zone_name
    zone_id                = var.r53_hosted_zone_id
    evaluate_target_health = true
  }
}
