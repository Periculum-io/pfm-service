variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type = string
}

variable "ecs_cluster_capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster."
  type = list(string)
}

variable "ecs_container_insights_enabled" {
  description = "Indicates if advanced monitoring (container insights) should be enabled on ECS cluster"
  type = string
}

variable "vpc_public_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for public subnets"
}

variable "vpc_private_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for private subnets"
}

variable "alb_log_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured"
  type = string
}

variable "alb_log_enabled" {
  description = "Boolean to enable / disable access_logs"
  type = bool
}

variable "alb_s3_bucket_acl" {
  description = "ACL type"
  type = string
}

variable "r53_hosted_zone_id" {
  type = string
  description = "ID of the zone that will be manipulated"
}

variable "r53_hosted_zone_id_insights_consumer_kenya" {
  type = string
  description = "ID of the zone that will be manipulated for insights consumer for Kenya"
}

variable "r53_target_domain_insights_consumer_kenya_1" {
  type = string
  description = "Domain where insights consumer kenya will be exposed to (utambuzi.com)"
}

variable "r53_target_domain_insights_consumer_kenya_2" {
  type = string
  description = "Domain where insights consumer kenya will be exposed to (www.utambuzi.com)"
}

variable "r53_target_domain" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_mono_integration" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_dojah_integration" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_consumer_frontend" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_consumer_backend" {
  type = string
  description = "Domain where the backend application shall be exposed to"
}

variable "s3_buckets_count" {
  type = number
  description = "Number of s3 buckets to be created via infrastructure module."
}

variable "s3_bucket_names" {
  type = list(string)
  description = "Names of s3 buckets."
}

variable "insights_consumer_s3_buckets_count" {
  type = number
  description = "Number of s3 buckets to be created via infrastructure module."
}

variable "insights_consumer_s3_bucket_names" {
  type = list(string)
  description = "Names of s3 buckets."
}

variable "mono_integration_buckets_count" {
  type = number
  description = "Number of s3 buckets to be created via infrastructure module."
}

variable "mono_integration_bucket_names" {
  type = list(string)
  description = "Names of s3 buckets."
}

variable "dojah_integration_buckets_count" {
  type = number
  description = "Number of s3 buckets to be created via infrastructure module."
}

variable "dojah_integration_bucket_names" {
  type = list(string)
  description = "Names of s3 buckets."
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
}

variable "rds_instance_class_insights_consumer" {
  type = string
  description = "The instance type of the RDS instance."
}

variable "rds_instance_class_mono_integration" {
  type = string
  description = "The instance type of the RDS instance."
}

variable "rds_instance_class_dojah_integration" {
  type = string
  description = "The instance type of the RDS instance."
}

variable "rds_multi_az_enabled" {
  type = bool
}

variable "rds_multi_az_enabled_insights_consumer" {
  type = bool
}

variable "rds_multi_az_enabled_mono_integration" {
  type = bool
}

variable "rds_multi_az_enabled_dojah_integration" {
  type = bool
}

variable "rds_availability_zone" {
  type = string
}

variable "rds_availability_zone_insights_consumer" {
  type = string
}

variable "rds_availability_zone_mono_integration" {
  type = string
}

variable "rds_availability_zone_dojah_integration" {
  type = string
}

variable "rds_backup_retention_period" {
  type = number
  description = "The days to retain backups for."
}

variable "rds_backup_retention_period_insights_consumer" {
  type = number
  description = "The days to retain backups for."
}

variable "rds_backup_retention_period_mono_integration" {
  type = number
  description = "The days to retain backups for."
}

variable "rds_backup_retention_period_dojah_integration" {
  type = number
  description = "The days to retain backups for."
}

variable "rds_delete_backups" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
}

variable "rds_delete_backups_insights_consumer" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
}

variable "rds_delete_backups_mono_integration" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
}

variable "rds_delete_backups_dojah_integration" {
  type = bool
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
}

variable "rds_deletion_protection" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
}

variable "rds_deletion_protection_insights_consumer" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
}

variable "rds_deletion_protection_mono_integration" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
}

variable "rds_deletion_protection_dojah_integration" {
  type = bool
  description = "If the DB instance should have deletion protection enabled."
}

variable "rds_skip_final_snapshot" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
}

variable "rds_skip_final_snapshot_insights_consumer" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
}

variable "rds_skip_final_snapshot_mono_integration" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
}

variable "rds_skip_final_snapshot_dojah_integration" {
  type = bool
  description = "If snapshot should be taken when db is destroyed"
}

variable "rds_secret_name" {
  type = string
  description = "Name of secret where credentials to RDS masteruser will be stored."
}

variable "rds_secret_name_insights_consumer" {
  type = string
  description = "Name of secret where credentials to RDS masteruser will be stored for insights consumer platform."
}

variable "rds_secret_name_mono_integration" {
  type = string
  description = "Name of secret where credentials to RDS masteruser will be stored."
}

variable "rds_secret_name_dojah_integration" {
  type = string
  description = "Name of secret where credentials to RDS masteruser will be stored."
}