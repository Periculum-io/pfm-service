variable "rds_kms_key_alias_names" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance for pdf processing."
  default = ["pfm-rds-key", "pfm-rds-key"]
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

variable "aws_db_subnet_group" {
  description = "The Insights DB subnet group"
  type = string
  default = null
}

variable "rds_allocated_storage" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_max_allocated_storage" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_instance_class" {
  type = string
  description = "The instance type of the RDS instance."
  default = "db.t3.micro"
}

variable "rds_multi_az_enabled" {
  type = bool
  default = false
}

variable "rds_availability_zone" {
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

variable "rds_deletion_protection" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
  default = false
}

variable "rds_skip_final_snapshot" {
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