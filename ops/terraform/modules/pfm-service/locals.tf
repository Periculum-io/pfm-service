locals {
  environment = var.environment
  service_name = var.service_name
  resource_name_prefix = "${local.environment}-${local.service_name}"
  common_tags = {
    environment = local.environment
  }
}