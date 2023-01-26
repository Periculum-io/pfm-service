data "aws_route53_zone" "route53_zone_pfm" {
  name = var.ec2_lb_hosted_zone_domain
}

resource "aws_acm_certificate" "acm_certificate_pfm" {
  domain_name       = var.ec2_lb_domain_name
  validation_method = "DNS"

  tags = {
    "Application" = "PDF Processing"
  }
}

resource "aws_route53_record" "certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate_pfm.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.route53_zone_pfm.zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation_pfm" {
  certificate_arn         = aws_acm_certificate.acm_certificate_pfm.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_record : record.fqdn]
}