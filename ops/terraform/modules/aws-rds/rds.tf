resource "aws_kms_key" "kms_key_for_rds" {
  count                   = length(var.rds_kms_key_alias_names)
  description             = "${local.resource_name_prefix}-${var.rds_kms_key_alias_names[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_rds_insights_consumer" {
  count                   = length(var.rds_kms_key_alias_names_insights_consumer)
  description             = "${local.resource_name_prefix}-${var.rds_kms_key_alias_names_insights_consumer[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_rds_mono_integration" {
  count                   = length(var.rds_kms_key_alias_names_mono_integration)
  description             = "${local.resource_name_prefix}-${var.rds_kms_key_alias_names_mono_integration[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_rds_dojah_integration" {
  count                   = length(var.rds_kms_key_alias_names_dojah_integration)
  description             = "${local.resource_name_prefix}-${var.rds_kms_key_alias_names_dojah_integration[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias_rds" {
  count         = length(var.rds_kms_key_alias_names)
  name          = "alias/${local.resource_name_prefix}-${var.rds_kms_key_alias_names[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds[count.index].key_id
}

resource "aws_kms_alias" "kms_key_alias_rds_insights_consumer" {
  count         = length(var.rds_kms_key_alias_names_insights_consumer)
  name          = "alias/${local.resource_name_prefix}-${var.rds_kms_key_alias_names_insights_consumer[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds_insights_consumer[count.index].key_id
}

resource "aws_kms_alias" "kms_key_alias_rds_mono_integration" {
  count         = length(var.rds_kms_key_alias_names_mono_integration)
  name          = "alias/${local.resource_name_prefix}-${var.rds_kms_key_alias_names_mono_integration[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds_mono_integration[count.index].key_id
}

resource "aws_kms_alias" "kms_key_alias_rds_dojah_integration" {
  count         = length(var.rds_kms_key_alias_names_dojah_integration)
  name          = "alias/${local.resource_name_prefix}-${var.rds_kms_key_alias_names_dojah_integration[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds_dojah_integration[count.index].key_id
}

resource "aws_db_subnet_group" "db_subnet_group_insights" {
  name       = "${local.resource_name_prefix}-insights-private"
  #subnet_ids = aws_subnet.insights_private_subnet[*].id
  subnet_ids = var.rds_subnet_ids

  tags = local.common_tags
}

resource "aws_db_parameter_group" "db_parameter_group_insights_business" {
  name   = "${local.resource_name_prefix}-insights-business-postgresql"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    apply_method  = "pending-reboot"
    name          = "max_connections"
    value         = "500"
  }
}

resource "aws_db_parameter_group" "db_parameter_group_insights" {
  name   = "${local.resource_name_prefix}-insights-postgresql"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "random_password" "rds_password" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

resource "random_password" "rds_password_insights_consumer" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

resource "random_password" "rds_password_mono_integration" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

resource "random_password" "rds_password_dojah_integration" {
  length           = 24
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = var.secret_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "rds_credentials_insights_consumer" {
  name = var.rds_secret_name_insights_consumer
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "rds_credentials_mono_integration" {
  name = var.rds_secret_name_mono_integration
  recovery_window_in_days = 0
}

data "aws_secretsmanager_secret" "rds_credentials_dojah_integration" {
  name = var.rds_secret_name_dojah_integration
}

locals {
  rds_username = "masteruser"
  rds_secret_string = {
    username = local.rds_username
    password = random_password.rds_password.result
  }
  rds_secret_string_insights_consumer = {
    username = local.rds_username
    password = random_password.rds_password_insights_consumer.result
  }
  rds_secret_string_mono_integration = {
    username = local.rds_username
    password = random_password.rds_password_mono_integration.result
  }
  rds_secret_string_dojah_integration = {
    username = local.rds_username
    password = random_password.rds_password_dojah_integration.result
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode(local.rds_secret_string)
}

resource "aws_secretsmanager_secret_version" "rds_credentials_insights_consumer_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials_insights_consumer.id
  secret_string = jsonencode(local.rds_secret_string_insights_consumer)
}

resource "aws_secretsmanager_secret_version" "rds_credentials_mono_integration_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials_mono_integration.id
  secret_string = jsonencode(local.rds_secret_string_mono_integration)
}

resource "aws_secretsmanager_secret_version" "rds_credentials_dojah_integration_version" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials_dojah_integration.id
  secret_string = jsonencode(local.rds_secret_string_dojah_integration)
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
  name_prefix        = "${local.resource_name_prefix}-insights-rds-enhanced-monitoring"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_rds_enhanced_monitoring" {
  role       = aws_iam_role.iam_role_rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "security_group_insights_rds" {
  name              = "${local.resource_name_prefix}-insights-rds-security-group"
  description       = "RDS security group to allow only inbound traffic from insights-api and pdf processor"
  vpc_id            = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-rds-security-group"
    },
  )
}

resource "aws_security_group" "security_group_insights_consumer_rds" {
  name              = "${local.resource_name_prefix}-insights-consumer-rds-security-group"
  description       = "RDS security group to allow only inbound traffic from insights-api and pdf processor"
  vpc_id            = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-consumer-rds-security-group"
    },
  )
}

resource "aws_security_group" "security_group_insights_mono_integration_rds" {
  name              = "${local.resource_name_prefix}-insights-mono-integration-rds-security-group"
  description       = "RDS security group to allow only inbound traffic from mono-integration-api and mono integration handler"
  vpc_id            = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-mono-integration-rds-security-group"
    },
  )
}

resource "aws_security_group" "security_group_insights_dojah_integration_rds" {
  name              = "${local.resource_name_prefix}-insights-dojah-integration-rds-security-group"
  description       = "RDS security group to allow only inbound traffic from dojah-integration-api and dojah integration handler"
  vpc_id            = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-dojah-integration-rds-security-group"
    },
  )
}

resource "aws_security_group_rule" "insights_rds_security_group_rule_insights_api" {
  count                     = length(var.rds_source_security_group_ids)
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_insights_rds.id
  source_security_group_id  = var.rds_source_security_group_ids[count.index]
}

resource "aws_security_group_rule" "insights_rds_security_group_rule_insights_consumer_api" {
  count                     = length(var.rds_insights_consumer_source_security_group_ids)
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_insights_consumer_rds.id
  source_security_group_id  = var.rds_insights_consumer_source_security_group_ids[count.index]
}

resource "aws_security_group_rule" "insights_mono_integration_rds_security_group_rule_insights_api" {
  count                     = length(var.rds_mono_integration_source_security_group_ids)
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_insights_mono_integration_rds.id
  source_security_group_id  = var.rds_mono_integration_source_security_group_ids[count.index]
}

resource "aws_security_group_rule" "insights_dojah_integration_rds_security_group_rule_insights_api" {
  count                     = length(var.rds_dojah_integration_source_security_group_ids)
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  security_group_id         = aws_security_group.security_group_insights_dojah_integration_rds.id
  source_security_group_id  = var.rds_dojah_integration_source_security_group_ids[count.index]
}

resource "aws_db_instance" "db_instance_insights" {
  identifier = "${local.resource_name_prefix}-insights-postgresql"

  storage_type            = "gp2"
  allocated_storage       = var.rds_allocated_storage
  max_allocated_storage   = var.rds_max_allocated_storage
  backup_retention_period = var.rds_backup_retention_period

  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.rds_instance_class
  multi_az             = var.rds_multi_az_enabled
  availability_zone    = var.rds_multi_az_enabled ? null : var.rds_availability_zone
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group_insights.name

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

  parameter_group_name = aws_db_parameter_group.db_parameter_group_insights_business.name
  vpc_security_group_ids = [aws_security_group.security_group_insights_rds.id]
  username = local.rds_username
  password = random_password.rds_password.result

  tags = local.common_tags
}

resource "aws_db_instance" "db_instance_insights_consumer" {
  identifier = "${local.resource_name_prefix}-insights-consumer-postgresql"

  storage_type            = "gp2"
  allocated_storage       = var.rds_allocated_storage_insights_consumer
  max_allocated_storage   = var.rds_max_allocated_storage_insights_consumer
  backup_retention_period = var.rds_backup_retention_period_insights_consumer

  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.rds_instance_class_insights_consumer
  multi_az             = var.rds_multi_az_enabled_insights_consumer
  availability_zone    = var.rds_multi_az_enabled_insights_consumer ? null : var.rds_multi_az_enabled_insights_consumer
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group_insights.name

  allow_major_version_upgrade     = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade      = var.rds_allow_minor_version_upgrade
  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports

  maintenance_window       = var.rds_maintenance_window
  backup_window            = var.rds_backup_window
  delete_automated_backups = var.rds_delete_backups_insights_consumer
  deletion_protection      = var.rds_deletion_protection_insights_consumer

  iam_database_authentication_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.kms_key_for_rds_insights_consumer[0].arn

  publicly_accessible = false
  skip_final_snapshot = var.rds_skip_final_snapshot_insights_consumer
  monitoring_interval = 10
  monitoring_role_arn = aws_iam_role.iam_role_rds_enhanced_monitoring.arn
  performance_insights_enabled = var.rds_performance_insights_enabled
  performance_insights_kms_key_id = aws_kms_key.kms_key_for_rds_insights_consumer[1].arn

  parameter_group_name = aws_db_parameter_group.db_parameter_group_insights.name
  vpc_security_group_ids = [aws_security_group.security_group_insights_consumer_rds.id]
  username = local.rds_username
  password = random_password.rds_password_insights_consumer.result

  tags = local.common_tags
}

resource "aws_db_instance" "db_instance_insights_mono_integration" {
  identifier = "${local.resource_name_prefix}-insights-mono-integration-postgresql"

  storage_type            = "gp2"
  allocated_storage       = var.rds_allocated_storage_mono_integration
  max_allocated_storage   = var.rds_max_allocated_storage_mono_integration
  backup_retention_period = var.rds_backup_retention_period_mono_integration

  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.rds_instance_class_mono_integration
  multi_az             = var.rds_multi_az_enabled_mono_integration
  availability_zone    = var.rds_multi_az_enabled_mono_integration ? null : var.rds_availability_zone_mono_integration
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group_insights.name

  allow_major_version_upgrade     = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade      = var.rds_allow_minor_version_upgrade
  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports

  maintenance_window       = var.rds_maintenance_window
  backup_window            = var.rds_backup_window
  delete_automated_backups = var.rds_delete_backups_mono_integration
  deletion_protection      = var.rds_deletion_protection_mono_integration

  iam_database_authentication_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.kms_key_for_rds_mono_integration[0].arn

  publicly_accessible = false
  skip_final_snapshot = var.rds_skip_final_snapshot_mono_integration
  monitoring_interval = 10
  monitoring_role_arn = aws_iam_role.iam_role_rds_enhanced_monitoring.arn
  performance_insights_enabled = var.rds_performance_insights_enabled
  performance_insights_kms_key_id = aws_kms_key.kms_key_for_rds_mono_integration[1].arn

  parameter_group_name = aws_db_parameter_group.db_parameter_group_insights.name
  vpc_security_group_ids = [aws_security_group.security_group_insights_mono_integration_rds.id]
  username = local.rds_username
  password = random_password.rds_password_mono_integration.result

  tags = local.common_tags
}

resource "aws_db_instance" "db_instance_insights_dojah_integration" {
  identifier = "${local.resource_name_prefix}-insights-dojah-integration-postgresql"

  storage_type            = "gp2"
  allocated_storage       = var.rds_allocated_storage_dojah_integration
  max_allocated_storage   = var.rds_max_allocated_storage_dojah_integration
  backup_retention_period = var.rds_backup_retention_period_dojah_integration

  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.rds_instance_class_dojah_integration
  multi_az             = var.rds_multi_az_enabled_dojah_integration
  availability_zone    = var.rds_multi_az_enabled_dojah_integration ? null : var.rds_availability_zone_dojah_integration
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group_insights.name

  allow_major_version_upgrade     = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade      = var.rds_allow_minor_version_upgrade
  enabled_cloudwatch_logs_exports = var.rds_cloudwatch_logs_exports

  maintenance_window       = var.rds_maintenance_window
  backup_window            = var.rds_backup_window
  delete_automated_backups = var.rds_delete_backups_dojah_integration
  deletion_protection      = var.rds_deletion_protection_dojah_integration

  iam_database_authentication_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.kms_key_for_rds_dojah_integration[0].arn

  publicly_accessible = false
  skip_final_snapshot = var.rds_skip_final_snapshot_dojah_integration
  monitoring_interval = 10
  monitoring_role_arn = aws_iam_role.iam_role_rds_enhanced_monitoring.arn
  performance_insights_enabled = var.rds_performance_insights_enabled
  performance_insights_kms_key_id = aws_kms_key.kms_key_for_rds_dojah_integration[1].arn

  parameter_group_name = aws_db_parameter_group.db_parameter_group_insights.name
  vpc_security_group_ids = [aws_security_group.security_group_insights_dojah_integration_rds.id]
  username = local.rds_username
  password = random_password.rds_password_dojah_integration.result

  tags = local.common_tags
}
