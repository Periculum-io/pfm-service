# Generic
environment = "dev"
aws_region = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]

# Infra related
ecs_cluster_name = "pfm-ecs-cluster"
ecs_cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]
ecs_container_insights_enabled = "disabled"
vpc_public_subnets_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
vpc_private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]

alb_log_prefix = "alb"
alb_log_enabled = true
alb_s3_bucket_acl = "private"

s3_buckets_count = 1
s3_bucket_names = ["pfm-s3-bucket"]

rds_allocated_storage = 10
rds_max_allocated_storage = 40
rds_instance_class = "db.t3.micro"
rds_multi_az_enabled = true
rds_availability_zone = "us-east-1a"
rds_backup_retention_period = 7
rds_deletion_protection = false
rds_delete_backups = true
rds_skip_final_snapshot = true
rds_secret_name = "pfm/dev/rds"

# Routing related
alb_listener_routing_host_pfm_api = "api.dev.pfm.com"
r53_hosted_zone_id = "Z0925464379UEHOR9ROUU"
r53_target_domain = "*.dev.pfm.com"

# Frontend
frontend_cpu_units = 512
frontend_ram_units = 1024
frontend_ecr_url = "962374658537.dkr.ecr.us-east-1.amazonaws.com/insights-frontend"
frontend_version = "latest"
frontend_task_count = 1
frontend_container_port = 80
frontend_container_host_port = 80
frontend_base_url = "https://api.dev.insights-periculum.com"

# PFM-API
insights_api_cpu_units = 512
insights_api_ram_units = 1024
insights_api_ecr_url = "962374658537.dkr.ecr.us-east-1.amazonaws.com/insights-statement-analytics-platform-api"
insights_api_version = "latest"
insights_api_task_count = 1
insights_api_container_port = 8001
insights_api_container_host_port = 8001
insights_api_allowed_cors_origin = "https://perilenda.dev.insights-periculum.com"
insights_api_auth0_domain = "https://periculum-insights-dev.us.auth0.com/"
insights_api_auth0_audience = "https://api.dev.insights-periculum.com"