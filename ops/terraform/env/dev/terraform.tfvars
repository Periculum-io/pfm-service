aws_region                    = "us-east-1"
environment                   = "dev"
resource_name_prefix          = "pfm"

vpc_id                        = "vpc-014bfbd3f00327eef"
vpc_pfm_public_subnets        = [ "subnet-0b9c698432334975f", "subnet-06e82436f3260a957" ]
vpc_pfm_private_subnets       = [ "subnet-016820b574afcf03a", "subnet-0a2a871e51f705350" ]

# Infra related
ecs_cluster_name               = "pfm-ecs-cluster"
ecs_cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]
ecs_container_insights_enabled = "disabled"
vpc_public_subnets_cidr        = ["10.0.0.0/24", "10.0.1.0/24"]
vpc_private_subnets_cidr       = ["10.0.2.0/24", "10.0.3.0/24"]

alb_log_prefix                 = "alb"
alb_log_enabled                = true
alb_s3_bucket_acl              = "private"
alb_s3_bucket_id               = "dev-pfm-logs-s3-bucket"

# Routing related
r53_hosted_zone_id                    = "Z05688392G271FHDECHWN"
r53_hosted_zone_name                  = "periculum-models.link"
r53_target_domain_pfm_admin_api       = "admin-api.pfm.dev.periculum-models.link"
r53_target_domain_pfm_admin_frontend  = "*.pfm.dev.periculum-models.link"
r53_target_domain_pfm_flask_api        = "api.pfm.dev.periculum-models.link"

# Frontend
frontend_cpu_units              = 512
frontend_ram_units              = 1024
frontend_ecr_url                = "962374658537.dkr.ecr.us-east-1.amazonaws.com/pfm-admin-frontend"
frontend_version                = "latest"
frontend_task_count             = 1
frontend_container_port         = 80
frontend_container_host_port    = 80
frontend_base_url               = "admin-api.pfm.dev.periculum-models.link"


# Platform-API
pfm_admin_api_cpu_units                 = 512
pfm_admin_api_ram_units                 = 1024
pfm_admin_api_ecr_url                   = "962374658537.dkr.ecr.us-east-1.amazonaws.com/pfm-admin-api"
pfm_admin_api_version                   = "latest"
pfm_admin_api_task_count                = 1
pfm_admin_api_container_port            = 8001
pfm_admin_api_container_host_port       = 8001
pfm_admin_api_sensitive_secret_arn      = "arn:aws:secretsmanager:us-east-1:962374658537:secret:Insights/dev/sensitive-secrets-wVaGKE"
pfm_admin_api_allowed_cors_origin       = "https://pfm.dev.periculum-models.link"
pfm_admin_api_auth0_domain              = "https://periculum-insights-dev.us.auth0.com/"
pfm_admin_api_auth0_audience            = "https://api.dev.insights-periculum.com"

# Flask Infrastructure 
bucket_names                            = ["pfm-bucket"]
ec2_ami_id                              = "ami-052efd3df9dad4825"
ec2_instance_type                       = "t3.micro"
ec2_insights_private_subnet_us_east_1a  = "subnet-016820b574afcf03a"
ec2_ssh_private_key_secret_name         = "pfm/dev/ec2/key"
ec2_ssh_public_key_secret_name          = "pfm/dev/ec2/key.pub"
ec2_lb_log_prefix                       = "lb"
ec2_lb_log_enabled                      = true

rds_kms_key_alias_names_pfm             = ["pfm-rds-key", "pfm-rds-performance-key"]
pfm_aws_db_subnet_group                 = "dev-insights-private"
rds_allocated_storage                   = 10
rds_max_allocated_storage               = 40
rds_instance_class                      = "db.t3.small"
rds_multi_az_enabled                    = true
rds_availability_zone                   = "us-east-1a"
rds_allow_major_version_upgrade         = false
rds_allow_minor_version_upgrade         = true
rds_backup_retention_period             = 7
rds_backup_window                       = "00:00-01:00"
rds_maintenance_window                  = "Sat:00:00-Sat:06:00"
rds_delete_backups                      = false
rds_deletion_protection                 = true
rds_skip_final_snapshot                 = false
rds_cloudwatch_logs_exports             = ["postgresql", "upgrade"]
rds_username                            = "masteruser"

ec2_lb_hosted_zone_domain               = "periculum-models.link"
ec2_lb_domain_name                      = "api.pfm.dev.periculum-models.link"

secrets_manager_vm_github_personal_access_token_arn = "arn:aws:secretsmanager:us-east-1:962374658537:secret:pdf-parser/prod/ec2/github-Ef5lEy"
