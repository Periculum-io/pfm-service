resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = local.resource_name_prefix
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu_units
  memory                   = var.task_ram_units

  task_role_arn            = aws_iam_role.iam_role_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.iam_role_ecs_task_execution_role.arn

  container_definitions = jsonencode(local.ecs_container_definitions)
}

resource "aws_ecs_service" "ecs_service" {
  depends_on = [
    aws_ecs_task_definition.ecs_task_definition,
    aws_alb_target_group.alb_target_group,
  ]

  name                = "${local.resource_name_prefix}-service"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count       = var.ecs_service_task_count
  launch_type         = "FARGATE"

  network_configuration {
    assign_public_ip  = false
    security_groups   = [aws_security_group.security_group_ecs_service.id]
    subnets           = var.subnet_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.id
    container_name   = local.ecs_container_definitions[0].name
    container_port   = var.container_port
  }
}