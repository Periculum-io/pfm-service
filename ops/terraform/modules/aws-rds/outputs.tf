output "security_group_id" {
  description = "ID of SG that is attached to RDS instance."
  value = aws_security_group.security_group_insights_rds.id
}

output "rds_host" {
  value = aws_db_instance.db_instance_insights.address
}

output "rds_port" {
  value = aws_db_instance.db_instance_insights.port
}

output "rds_username" {
  value = local.rds_username
}

output "rds_password" {
  value = random_password.rds_password.result
}
