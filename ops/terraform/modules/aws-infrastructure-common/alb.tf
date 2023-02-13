resource "aws_cloudwatch_log_group" "cloudwatch_log_group_pfm" {
  name = "/ecs/${local.environment}-${local.resource_name_prefix}-cloudwatch-log-group"
}

data "aws_elb_service_account" "elb_service_account_insights" {
}

resource "aws_s3_bucket" "s3_bucket_logs" {
  bucket        = "${local.environment}-${local.resource_name_prefix}-logs-s3-bucket"
  acl           = var.alb_s3_bucket_acl
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
        "Resource": "arn:aws:s3:::${local.environment}-${local.resource_name_prefix}-logs-s3-bucket/*/*",
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
  bucket = aws_s3_bucket.s3_bucket_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "security_group_pfm_alb" {
  name              = "${local.environment}-${local.resource_name_prefix}-alb-security-group"
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

  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}-${local.resource_name_prefix}-alb-security-group"
    },
  )
}

resource "aws_alb" "alb_pfm" {
  name            = "${local.environment}-${local.resource_name_prefix}-alb"
  subnets         = var.vpc_pfm_public_subnets
  security_groups = [aws_security_group.security_group_pfm_alb.id]

  access_logs {
    bucket        = var.alb_s3_bucket_id
    prefix        = var.alb_log_prefix
    enabled       = var.alb_log_enabled
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}-${local.resource_name_prefix}-alb"
    },
  )
}