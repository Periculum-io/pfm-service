resource "aws_security_group" "security_group_ecs_service" {
  name              = "${local.environment}-${local.resource_name_prefix}-ecs-service-security-group"
  description       = "Allow inbound access from the public ALB only"
  vpc_id            = var.vpc_id

  # Egress is ALLOW ALL because the task needs to download Docker image from ECR
  #   -> could be modified to only allow AWS IP range
  egress {
    protocol        = -1
    from_port       = "0"
    to_port         = "0"
    cidr_blocks     = [ "0.0.0.0/0" ]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}-${local.resource_name_prefix}-ecs-service-security-group"
    },
  )
}

resource "aws_security_group_rule" "security_group_rule" {
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = var.security_group_alb_to_port
  to_port                   = var.container_port
  security_group_id         = aws_security_group.security_group_ecs_service.id
  source_security_group_id  = var.source_security_group_alb_id
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "${local.environment}-${local.resource_name_prefix}-ecs-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path      = "/healthz"
    port      = var.container_port
    protocol  = "HTTP"

  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.environment}-${local.resource_name_prefix}-ecs-tg"
    },
  )
}
