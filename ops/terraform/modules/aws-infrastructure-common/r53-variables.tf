variable "r53_hosted_zone_id" {
  type = string
  description = "ID of the zone that will be manipulated"
}

variable "r53_hosted_zone_name" {
  type = string
  description = "Name of the zone that will be manipulated"
}

variable "r53_target_domain_pfm_admin_api" {
  type = string
  description = "Domain where the api shall be exposed to"
}

variable "r53_target_domain_pfm_admin_frontend" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_pfm_flask_api" {
  type = string
  description = "Domain where the flask API shall be exposed to"
}

