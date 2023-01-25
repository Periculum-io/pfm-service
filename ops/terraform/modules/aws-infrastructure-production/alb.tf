resource "aws_cloudwatch_log_group" "cloudwatch_log_group_insights" {
  name = "/ecs/${local.resource_name_prefix}-insights-cloudwatch-log-group"
}

data "aws_elb_service_account" "elb_service_account_insights" {
}

resource "aws_s3_bucket" "s3_bucket_insights_logs" {
  bucket        = "${local.resource_name_prefix}-insights-logs-s3-bucket"
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
        "Resource": "arn:aws:s3:::${local.resource_name_prefix}-insights-logs-s3-bucket/*/*",
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
  bucket = aws_s3_bucket.s3_bucket_insights_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "security_group_insights_alb" {
  name              = "${local.resource_name_prefix}-insights-alb-security-group"
  description       = "ALB security group to allow all inbound/outbound"
  vpc_id            = aws_vpc.insights_vpc.id
  depends_on        = [aws_vpc.insights_vpc]

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
      Name = "${local.resource_name_prefix}-insights-alb-security-group"
    },
  )
}

resource "aws_alb" "alb_insights" {
  name            = "${local.resource_name_prefix}-insights-alb"
  subnets         = aws_subnet.insights_public_subnet.*.id
  security_groups = [aws_security_group.security_group_insights_alb.id]

  access_logs {
    bucket        = aws_s3_bucket.s3_bucket_insights_logs.id
    prefix        = var.alb_log_prefix
    enabled       = var.alb_log_enabled
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-alb"
    },
  )
}