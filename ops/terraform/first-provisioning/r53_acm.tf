locals {
  dns_zone = "periculum-models.link"
  certificate_domain_names = [
    "*.pfm.periculum-models.link",
    "*.pfm.dev.periculum-models.link",
    "*.pfm.staging.periculum-models.link"
    ]
}

data "aws_route53_zone" "route53_zone_name" {
  name = local.dns_zone
  private_zone = false
}

resource "aws_acm_certificate" "acm_certificate_pfm" {
  for_each          = toset(local.certificate_domain_names)
  domain_name       = each.key
  validation_method = "DNS"

  tags = {
    "Application" = "PFM"
  }

  lifecycle {
    create_before_destroy = true
  }

  # validation_option {
  #   domain_name       = toset(local.certificate_domain_names)
  #   validation_domain = local.dns_zone
  # }
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
  zone_id         = data.aws_route53_zone.route53_zone_name.zone_id
}

resource "aws_acm_certificate_validation" "ec2_certificate_validation" {
  certificate_arn         = data.aws_acm_certificate.acm_certificate_pfm.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation_record : record.fqdn]
}