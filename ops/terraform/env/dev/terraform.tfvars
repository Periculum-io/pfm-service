aws_region                    = "us-east-1"
environment                   = "dev"
#availability_zones            = ["us-east-1a", "us-east-1b"] 
vpc_id = "vpc-014bfbd3f00327eef"
vpc_pfm_public_subnets = [ "subnet-0b9c698432334975f", "subnet-06e82436f3260a957" ]
vpc_pfm_private_subnets = ["subnet-016820b574afcf03a", "subnet-0a2a871e51f705350"]
 

# Infra related
ecs_cluster_name = "pfm-ecs-cluster"
ecs_cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]
ecs_container_insights_enabled = "disabled"
vpc_public_subnets_cidr = ["10.0.0.0/24", "10.0.1.0/24"]
vpc_private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]

alb_log_prefix = "alb"
alb_log_enabled = true
alb_s3_bucket_acl = "private"
alb_s3_bucket_id = ""



# Routing related
r53_hosted_zone_name = "periculum-models.link"
r53_target_domain_pfm_admin_api = "admin-api.pfm.dev.periculum-models.link"
r53_hosted_zone_id = "Z05688392G271FHDECHWN"
r53_target_domain_pfm_admin_frontend = "pfm.dev.periculum-models.link"

# Frontend
frontend_cpu_units = 512
frontend_ram_units = 1024
frontend_ecr_url = "962374658537.dkr.ecr.us-east-1.amazonaws.com/pfm-admin-frontend"
frontend_version = "latest"
frontend_task_count = 1
frontend_container_port = 80
frontend_container_host_port = 80
frontend_base_url = "admin-api.pfm.dev.periculum-models.link"


# Platform-API
pfm_admin_api_cpu_units = 512
pfm_admin_api_ram_units = 1024
pfm_admin_api_ecr_url = "962374658537.dkr.ecr.us-east-1.amazonaws.com/pfm-admin-api"
pfm_admin_api_version = "latest"
pfm_admin_api_task_count = 1
pfm_admin_api_container_port = 8001
pfm_admin_api_container_host_port = 8001
pfm_admin_api_sensitive_secret_arn = "arn:aws:secretsmanager:us-east-1:962374658537:secret:Insights/dev/sensitive-secrets-wVaGKE"
pfm_admin_api_allowed_cors_origin = "https://perilenda.dev.insights-periculum.com"
pfm_admin_api_auth0_domain = "https://periculum-insights-dev.us.auth0.com/"
pfm_admin_api_auth0_audience = "https://api.dev.insights-periculum.com"
