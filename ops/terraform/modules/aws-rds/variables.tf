variable "environment" {
  description = "Name of the environment"
  type = string
  default = "test"
}

variable "vpc_id" {
  type = string
}

variable "enc_key_deletion_in_days" {
  description = "How often should the encryption key be rotated"
  type = number
  default = 10
}

variable "enc_key_rotation_enabled" {
  description = "How often should the encryption key be rotated"
  type = bool
  default = true
}

variable "rds_kms_key_alias_names" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance insights."
  default = ["insights-rds-key", "insights-rds-performance-insights-key"]
}

variable "rds_kms_key_alias_names_insights_consumer" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance insights."
  default = ["insights-consumer-rds-key", "insights-consumer-rds-performance-insights-key"]
}

variable "rds_kms_key_alias_names_mono_integration" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance insights for the mono integration."
  default = ["insights-mono-integration-rds-key", "insights-mono-integration-rds-performance-insights-key"]
}

variable "rds_kms_key_alias_names_dojah_integration" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance insights for the dojah integration."
  default = ["insights-dojah-integration-rds-key", "insights-dojah-integration-rds-performance-insights-key"]
}

variable "rds_allocated_storage" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_allocated_storage_insights_consumer" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_allocated_storage_mono_integration" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_allocated_storage_dojah_integration" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_max_allocated_storage" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_max_allocated_storage_insights_consumer" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_max_allocated_storage_mono_integration" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_max_allocated_storage_dojah_integration" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_instance_class" {
  type = string
  description = "The instance type of the RDS instance."
  default = "db.t3.micro"
}

variable "rds_instance_class_insights_consumer" {
  type = string
  description = "The instance type of the RDS instance."
  default = "db.t3.micro"
}

variable "rds_instance_class_mono_integration" {
  type = string
  description = "The instance type of the RDS instance."
  default = "db.t3.micro"
}

variable "rds_instance_class_dojah_integration" {
  type = string
  description = "The instance type of the RDS instance."
  default = "db.t3.micro"
}

variable "rds_multi_az_enabled" {
  type = bool
  default = false
}

variable "rds_multi_az_enabled_insights_consumer" {
  type = bool
  default = false
}

variable "rds_multi_az_enabled_mono_integration" {
  type = bool
  default = false
}

variable "rds_multi_az_enabled_dojah_integration" {
  type = bool
  default = false
}

variable "rds_subnet_ids" {
  type = list(string)
  description = "List of subnet IDs the RDS instance should be placed in."
}

variable "rds_availability_zone" {
  type = string
  default = "us-east-1a"
}

variable "rds_availability_zone_insights_consumer" {
  type = string
  default = "us-east-1a"
}

variable "rds_availability_zone_mono_integration" {
  type = string
  default = "us-east-1a"
}

variable "rds_availability_zone_dojah_integration" {
  type = string
  default = "us-east-1a"
}

variable "rds_allow_major_version_upgrade" {
  type = bool
  description = "Indicates that major version upgrades are allowed"
  default = false
}

variable "rds_allow_minor_version_upgrade" {
  type = bool
  description = "Indicates that minor version upgrades are allowed"
  default = true
}

variable "rds_backup_retention_period" {
  type = number
  description = "The days to retain backups for."
  default = 7
}

variable "rds_backup_retention_period_insights_consumer" {
  type = number
  description = "The days to retain backups for."
  default = 7
}

variable "rds_backup_retention_period_mono_integration" {
  type = number
  description = "The days to retain backups for."
  default = 7
}

variable "rds_backup_retention_period_dojah_integration" {
  type = number
  description = "The days to retain backups for."
  default = 7
}

variable "rds_backup_window" {
  type = string
  description = "The daily time range (in UTC) during which automated backups are created."
  default = "08:00-09:00"
}

variable "rds_maintenance_window" {
  type = string
  description = "The window to perform maintenance in."
  default = "Sat:00:00-Sat:06:00"
}

variable "rds_delete_backups" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default = false
}

variable "rds_delete_backups_insights_consumer" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default = false
}

variable "rds_delete_backups_mono_integration" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default = false
}

variable "rds_delete_backups_dojah_integration" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default = false
}

variable "rds_deletion_protection" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
  default = false
}

variable "rds_deletion_protection_insights_consumer" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
  default = false
}

variable "rds_deletion_protection_mono_integration" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
  default = false
}

variable "rds_deletion_protection_dojah_integration" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
  default = false
}

variable "rds_skip_final_snapshot" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
  default = true
}

variable "rds_skip_final_snapshot_insights_consumer" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
  default = true
}

variable "rds_skip_final_snapshot_mono_integration" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
  default = true
}

variable "rds_skip_final_snapshot_dojah_integration" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
  default = true
}

variable "rds_cloudwatch_logs_exports" {
  type = set(string)
  description = "Set of log types to enable for exporting to CloudWatch logs."
  default = ["postgresql", "upgrade"]
}

variable "rds_performance_insights_enabled" {
  type = bool
  description = "Specifies whether Performance Insights are enabled."
  default = true
}

variable "rds_source_security_group_ids" {
  type = list(string)
  description = "list of SG IDs that will be allowed to initiate communication towards RDS"
}

variable "rds_insights_consumer_source_security_group_ids" {
  type = list(string)
  description = "list of SG IDs that will be allowed to initiate communication towards insights consumer RDS"
}

variable "rds_mono_integration_source_security_group_ids" {
  type = list(string)
  description = "list of SG IDs that will be allowed to initiate communication towards RDS"
}

variable "rds_dojah_integration_source_security_group_ids" {
  type = list(string)
  description = "list of SG IDs that will be allowed to initiate communication towards RDS"
}

variable "secret_name" {
  type = string
  description = "Name of secret where credentials to master user will be stored."
}

variable "rds_secret_name_insights_consumer" {
  type = string
  description = "Name of secret where credentials to master user will be stored."
}

variable "rds_secret_name_mono_integration" {
  type = string
  description = "Name of secret where credentials to master user will be stored."
}

variable "rds_secret_name_dojah_integration" {
  type = string
  description = "Name of secret where credentials to master user will be stored."
}