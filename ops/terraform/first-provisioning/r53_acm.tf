locals {
  dns_zone = "periculum-models.link"
  certificate_domain_names = [
    "api.pfm.periculum-models.link",
    "api.pfm.dev.periculum-models.link",
    "api.pfm.staging.periculum-models.link",
    "admin-api.pfm.periculum-models.link",
    "admin-api.pfm.dev.periculum-models.link",
    "admin-api.pfm.staging.periculum-models.link",
    "pfm.periculum-models.link",
    "pfm.dev.periculum-models.link",
    "pfm.staging.periculum-models.link"
    ]
}

data "aws_route53_zone" "route53_zone_pfm" {
  name = local.dns_zone

  tags = {
    Application = "pfm-periculum"
  }
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
}

