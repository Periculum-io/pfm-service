variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type = string
  default = "insights-ecs-cluster"
}

variable "ecs_cluster_capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster."
  type = list(string)
  default = ["FARGATE", "FARGATE_SPOT"]
}

variable "ecs_container_insights_enabled" {
  description = "Indicates if advanced monitoring (container insights) should be enabled on ECS cluster"
  type = string
  default = "disabled"
}