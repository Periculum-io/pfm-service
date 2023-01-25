resource "aws_kms_key" "kms_key_for_rds" {
  count                   = length(var.rds_kms_key_alias_names)
  description             = "${var.application_name}-${var.rds_kms_key_alias_names[count.index]}"
  deletion_window_in_days = var.enc_key_deletion_in_days
  enable_key_rotation     = var.enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias_rds" {
  count         = length(var.rds_kms_key_alias_names)
  name          = "alias/${var.application_name}-${var.rds_kms_key_alias_names[count.index]}"
  target_key_id = aws_kms_key.kms_key_for_rds[count.index].key_id
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.application_name}-postgresql"
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
  name_prefix        = "${var.application_name}-rds-em"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_rds_enhanced_monitoring" {
  role       = aws_iam_role.iam_role_rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "keycloakdb_sg" {
  name = "${var.application_name}-sg"
  description = "Security group for connecting to the KeyCloak database instance"

  vpc_id = var.vpc_id

  # Only PostgreSQL traffic inbound
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [ aws_security_group.instance_sg.id ]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main" {
  name = "${var.application_name}-db-sng"
  subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
}

resource "aws_db_instance" "keycloakdb" {
  identifier = "${var.application_name}-rds"

  storage_type = "gp2"
  allocated_storage = var.rds_storage_gigabytes
  backup_retention_period = var.rds_backup_retention_days

  engine = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_type
  multi_az = var.rds_multi_az
  db_subnet_group_name = aws_db_subnet_group.main.name

  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  enabled_cloudwatch_logs_exports = [ "postgresql", "upgrade" ]

  maintenance_window = "Sat:00:00-Sat:06:00"
  backup_window = "08:00-09:00"
  delete_automated_backups = false
  deletion_protection = true
  
  iam_database_authentication_enabled = true
  storage_encrypted = true
  kms_key_id = aws_kms_key.kms_key_for_rds[0].arn
  
  publicly_accessible = false
  skip_final_snapshot = true
  monitoring_interval = 10
  monitoring_role_arn = aws_iam_role.iam_role_rds_enhanced_monitoring.arn
  performance_insights_enabled = true
  performance_insights_kms_key_id = aws_kms_key.kms_key_for_rds[1].arn

  parameter_group_name = aws_db_parameter_group.db_parameter_group.name
  vpc_security_group_ids = [ aws_security_group.keycloakdb_sg.id ]
  username = var.rds_username
  password = random_password.rds_password.result

  tags = {
    Name = "${var.application_name}-rds"
  }
}