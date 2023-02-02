locals {
  environment = var.environment
  resource_name_prefix = var.resource_name_prefix
  #resource_name_prefix = "${local.environment}"
  common_tags = {
    environment = local.environment
  }
}