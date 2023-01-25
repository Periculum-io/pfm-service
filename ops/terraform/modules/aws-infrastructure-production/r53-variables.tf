variable "r53_hosted_zone_id" {
  type = string
  description = "ID of the zone that will be manipulated"
}

variable "r53_hosted_zone_id_insights_consumer_kenya" {
  type = string
  description = "ID of the zone that will be manipulated for insights consumer for Kenya"
}

variable "r53_target_domain_insights_consumer_kenya_1" {
  type = string
  description = "Domain where insights consumer kenya will be exposed to (utambuzi.com)"
}

variable "r53_target_domain_insights_consumer_kenya_2" {
  type = string
  description = "Domain where insights consumer kenya will be exposed to (www.utambuzi.com)"
}

variable "r53_target_domain" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_mono_integration" {
  type = string
  description = "Domain where the application shall be exposed to"
}

variable "r53_target_domain_dojah_integration" {
  type = string
  description = "Domain where the application shall be exposed to"
}