resource "aws_route53_record" "r53_record_a_domain" {
  zone_id = data.aws_route53_zone.route53_zone_pfm.zone_id
  name    = var.ec2_lb_domain_name
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_pfm" {
  name = "/alb/${local.resource_name_prefix}-cloudwatch-log-group"
}

data "aws_elb_service_account" "elb_service_account_pfm" {
}

resource "aws_s3_bucket" "s3_bucket_pfm_logs" {
  bucket        = "${local.resource_name_prefix}-logs-s3-bucket"
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
        "Resource": "arn:aws:s3:::${local.resource_name_prefix}-logs-s3-bucket/*/*",
        "Principal": {
          "AWS": [
            "${data.aws_elb_service_account.elb_service_account_pfm.arn}"
          ]
        }
      }
    ]
  }
  POLICY
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket_pfm_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "security_group_pfm_alb" {
  name              = "${local.resource_name_prefix}-alb-security-group"
  description       = "ALB security group to allow all inbound/outbound"
  vpc_id            = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    cidr_blocks     = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.resource_name_prefix}-alb-security-group"
  }
}

resource "aws_alb" "alb" {
  name            = "${local.resource_name_prefix}-alb"
  subnets         = [for subnet in data.aws_subnet.pfm_public_subnet : subnet.id]
  security_groups = [aws_security_group.security_group_pfm_alb.id]

  access_logs {
    bucket        = aws_s3_bucket.s3_bucket_pfm_logs.id
    prefix        = "alb"
    enabled       = true
  }

  tags = {
    Name = "${local.resource_name_prefix}-alb"
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn   = aws_alb.alb.arn
  port                = "443"
  protocol            = "HTTPS"

  certificate_arn     = aws_acm_certificate.acm_certificate_pfm.arn

  # If URL does not match any rule, it is currently being forwarded to pfm api
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2_load_balancer_pfm_target_group.arn
  }

  tags = {
      Name = "${local.resource_name_prefix}-alb-listener"
  }
}

resource "aws_lb_target_group" "ec2_load_balancer_pfm_target_group" {
  name      = "${local.resource_name_prefix}-ec2-tg"
  port      = 80
  protocol  = "HTTP"

  vpc_id    = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_load_balancer_pfm_api_instance_1_attachment" {
  target_group_arn  = aws_lb_target_group.ec2_load_balancer_pfm_target_group.arn
  target_id         = aws_instance.pfm_api_instance_1.id
  port              = 80
}
