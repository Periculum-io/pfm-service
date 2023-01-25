output "security_group_id" {
  description = "ID of SG that is attached to RDS instance."
  value = aws_security_group.security_group_insights_rds.id
}

output "mono_integration_rd_security_group_id" {
  description = "ID of SG that is attached to RDS instance."
  value = aws_security_group.security_group_insights_mono_integration_rds.id
}

output "dojah_integration_rd_security_group_id" {
  description = "ID of SG that is attached to RDS instance."
  value = aws_security_group.security_group_insights_dojah_integration_rds.id
}
output "insights_consumer_rd_security_group_id" {
  description = "ID of SG that is attached to RDS instance."
  value = aws_security_group.security_group_insights_consumer_rds.id
}


output "rds_host" {
  value = aws_db_instance.db_instance_insights.address
}

output "rds_port" {
  value = aws_db_instance.db_instance_insights.port
}

output "rds_host_mono_integration" {
  value = aws_db_instance.db_instance_insights_mono_integration
}

output "rds_host_dojah_integration" {
  value = aws_db_instance.db_instance_insights_dojah_integration
}

output "rds_port_mono_integration" {
  value = aws_db_instance.db_instance_insights_mono_integration.port
}

output "rds_port_dojah_integration" {
  value = aws_db_instance.db_instance_insights_dojah_integration.port
}

output "rds_host_insights_consumer" {
  value = aws_db_instance.db_instance_insights_consumer
}

output "rds_port_insights_consumer" {
  value = aws_db_instance.db_instance_insights_consumer.port
}

output "rds_username" {
  value = local.rds_username
}

output "rds_password" {
  value = random_password.rds_password.result
}

output "rds_username_insights_consumer" {
  value = local.rds_username
}

output "rds_password_insights_consumer" {
  value = random_password.rds_password_insights_consumer.result
}

output "rds_username_mono_integration" {
  value = local.rds_username
}

output "rds_username_dojah_integration" {
  value = local.rds_username
}

output "rds_password_mono_integration" {
  value = random_password.rds_password_mono_integration.result
}

output "rds_password_dojah_integration" {
  value = random_password.rds_password_dojah_integration.result
}