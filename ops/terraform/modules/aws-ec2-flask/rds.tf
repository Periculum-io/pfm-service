resource "random_password" "rds_password" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

# Keys
resource "aws_kms_key" "kms_key_for_rds" {
  count                   = length(var.rds_kms_key_alias_names)
  description             = "${local.environment}-${var.rds_kms_key_alias_names[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias_rds" {
  count         = length(var.rds_kms_key_alias_names)
  name          = "alias/${local.environment}-${var.rds_kms_key_alias_names[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds[count.index].key_id
}

# Networking
data "aws_db_subnet_group" "db_subnet_group_insights" {
  name = var.aws_db_subnet_group
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${local.environment}-${local.resource_name_prefix}-parameter-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "shared_preload_libraries"
    value = "pglogical"
    apply_method = "pending-reboot"
  }
}

resource "aws_security_group" "security_group_rds" {
  name              = "${local.environment}-${local.resource_name_prefix}-rds-security-group"
  description       = "RDS security group to allow only inbound traffic from ec2 instances that perform ${local.resource_name_prefix} analysis"
  vpc_id            = var.vpc_id

  tags = {
    Name = "${local.environment}-${local.resource_name_prefix}-rds-security-group"
  }
}

# Allow connectivity from EC2 to RDS
resource "aws_security_group_rule" "security_group_rule_rds_ingress" {
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_rds.id
  source_security_group_id  = aws_security_group.security_group_ec2.id
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_role_rds_enhanced_monitoring" {
  name_prefix        = "${local.environment}-${local.resource_name_prefix}-rds-em"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_rds_enhanced_monitoring" {
  role       = aws_iam_role.iam_role_rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "db_instance" {
  identifier = "${local.environment}-${local.resource_name_prefix}-rds-postgresql"

  storage_type            = "gp2"
  allocated_storage       = var.rds_allocated_storage
  max_allocated_storage   = var.rds_max_allocated_storage
  backup_retention_period = var.rds_backup_retention_period

  engine               = "postgres"
  engine_version       = "13.10"
  instance_class       = var.rds_instance_class
  multi_az             = var.rds_multi_az_enabled
  availability_zone    = var.rds_multi_az_enabled ? null : var.rds_availability_zone
  db_subnet_group_name = data.aws_db_subnet_group.db_subnet_group_insights.name

  allow_major_version_upgrade     = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade      = var.rds_allow_minor_version_upgrade
  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports

  maintenance_window       = var.rds_maintenance_window
  backup_window            = var.rds_backup_window
  delete_automated_backups = var.rds_delete_backups
  deletion_protection      = var.rds_deletion_protection

  iam_database_authentication_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.kms_key_for_rds[0].arn

  publicly_accessible = false
  skip_final_snapshot = var.rds_skip_final_snapshot
  monitoring_interval = 10
  monitoring_role_arn = aws_iam_role.iam_role_rds_enhanced_monitoring.arn
  performance_insights_enabled = var.rds_performance_insights_enabled
  performance_insights_kms_key_id = aws_kms_key.kms_key_for_rds[1].arn

  parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  vpc_security_group_ids = [aws_security_group.security_group_rds.id]
  username = var.rds_username
  password = random_password.rds_password.result
}

resource "aws_secretsmanager_secret" "db_credentials_secret" {
  name = "pfm/${var.environment}/rds"
}

resource "aws_secretsmanager_secret_version" "db_credentials_secret_version" {
  secret_id = aws_secretsmanager_secret.db_credentials_secret.id
  secret_string = jsonencode(local.rds_secret_string_pfm_integration)
}
