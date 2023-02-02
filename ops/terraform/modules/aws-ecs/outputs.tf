output "target_group_id" {
  value = aws_alb_target_group.alb_target_group.id
}

output "security_group_id" {
  value = aws_security_group.security_group_ecs_service.id
}