resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.environment}-${var.ecs_cluster_name}"
  capacity_providers = var.ecs_cluster_capacity_providers

  setting {
    name  = "containerInsights"
    value = var.ecs_container_insights_enabled
  }

  tags = local.common_tags
}