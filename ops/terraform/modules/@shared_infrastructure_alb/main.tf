resource "aws_security_group" "keycloak_alb_sg" {
  description = "The security group used to grant access to the keycloak ALB"

  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

data "aws_elb_service_account" "elb_service_account_insights" {
}

resource "aws_s3_bucket" "s3_bucket_keycloak_logs" {
  bucket        = "${var.alb_name}-logs-s3-bucket"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  policy = <<POLICY
  {
    "Id": "Policy",
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.alb_name}-logs-s3-bucket/*/*",
        "Principal": {
          "AWS": [
            "${data.aws_elb_service_account.elb_service_account_insights.arn}"
          ]
        }
      }
    ]
  }
  POLICY
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket_keycloak_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_alb" "keycloak_alb" {
  name            = var.alb_name
  subnets         = var.public_subnet_ids
  security_groups = [ aws_security_group.keycloak_alb_sg.id ]

  access_logs {
    bucket        = aws_s3_bucket.s3_bucket_keycloak_logs.id
    prefix        = var.alb_name
    enabled       = true
  }
  
  tags = {
    Name = var.alb_name
  }
}

resource "aws_acm_certificate" "main" {
  domain_name = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = {
    "Application" = "Keycloak"
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

resource "aws_alb_listener" "front_end_tls" {
  load_balancer_arn = aws_alb.keycloak_alb.id
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate.main.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code = "200"
    }
  }
}

resource "aws_route53_record" "r53_record_a_domain" {
  zone_id = var.zone_id
  name    = "*.${var.zone_name}"
  type    = "A"

  alias {
    name                   = aws_alb.keycloak_alb.dns_name
    zone_id                = aws_alb.keycloak_alb.zone_id
    evaluate_target_health = true
  }
}