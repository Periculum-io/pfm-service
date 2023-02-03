locals {
  environment = var.environment
  resource_name_prefix = "${var.resource_name_prefix}"
  common_tags = {
    environment = local.environment
  }
}