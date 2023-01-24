aws_region                    = "us-east-1"
dynamodb_table_name           = "periculum-pdf-parser-state"
dynamodb_table_read_capacity  = 20
dynamodb_table_write_capacity = 20

vpc_id = "vpc-01c4b586d9b30a704"
vpc_insights_public_subnets = [ "subnet-0fd50fcff1564b322", "subnet-03f99ef94eed8df92" ]

ec2_ami_id = "ami-052efd3df9dad4825"
ec2_instance_type = "t3.micro"
ec2_prod_insights_private_subnet_us_east_1a = "subnet-09727753b48abb509"
ec2_ssh_private_key_secret_name = "pdf-parser/prod/ec2/key"
ec2_ssh_public_key_secret_name = "pdf-parser/prod/ec2/key.pub"
ec2_lb_log_prefix = "lb"
ec2_lb_log_enabled = true

rds_kms_key_alias_names_pdf_processing = ["pdf-parser-rds-key", "pdf-parser-rds-performance-key"]
enc_key_deletion_in_days = 10
enc_key_rotation_enabled = true
insights_aws_db_subnet_group = "prod-insights-private"
rds_allocated_storage = 10
rds_max_allocated_storage = 40
rds_instance_class = "db.t3.small"
rds_multi_az_enabled = true
rds_availability_zone = "us-east-1a"
rds_allow_major_version_upgrade = false
rds_allow_minor_version_upgrade = true
rds_backup_retention_period = 7
rds_backup_window = "08:00-09:00"
rds_maintenance_window = "Sat:00:00-Sat:06:00"
rds_delete_backups = false
rds_deletion_protection = true
rds_skip_final_snapshot = false
rds_cloudwatch_logs_exports = ["postgresql", "upgrade"]
rds_performance_insights_enabled = true

buckets_count = 1
bucket_names = ["bucket"]
bucket_enc_key_deletion_in_days = 10
bucket_enc_key_rotation_enabled = true

sqs_queue_name = "queue"
sqs_fifo_queue = false
sqs_visibility_timeout_seconds = 15 * 60
sqs_message_retention_seconds = 345600
sqs_max_message_size = 262144
sqs_delay_seconds = 0
sqs_receive_wait_time_seconds = 10
sqs_max_receive_count = 5
sqs_enc_key_deletion_in_days = 10
sqs_enc_key_rotation_enabled = true

ec2_lb_hosted_zone_domain = "periculum-models.link"
ec2_lb_domain_name = "pdfprocessing.periculum-models.link"

secrets_manager_vm_github_personal_access_token_arn = "arn:aws:secretsmanager:us-east-1:962374658537:secret:pdf-parser/prod/ec2/github-Ef5lEy"
