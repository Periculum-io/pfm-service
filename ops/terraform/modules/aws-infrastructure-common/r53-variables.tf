variable "r53_hosted_zone_id" {
  type = string
  description = "ID of the zone that will be manipulated"
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