locals {
  environment = var.environment
  service_name = var.service_name
  resource_name_prefix = "${local.environment}-${local.service_name}"
  common_tags = {
    environment = local.environment
  }
}

locals {
  ecs_container_definitions = [
    {
      image       = "${var.container_image}:${var.container_tag}"
      name        = var.service_name,
      networkMode = "awsvpc",
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_host_port
        }
      ]
      secrets = var.task_secrets,
      environment = var.task_environment_variables
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.aws_cloudwatch_logs_group,
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = "ecs-${var.service_name}"
        }
      }
    }
  ]
}