variable "buckets_count" {
  type = number
  description = "How many buckets should be created."
}

variable "insights_consumer_s3_buckets_count" {
  type = number
  description = "How many buckets should be created for Insights Consumer platform"
}

variable "mono_integration_buckets_count" {
  type = number
  description = "How many buckets should be created for the Insights Mono integration."
}

variable "dojah_integration_buckets_count" {
  type = number
  description = "How many buckets should be created for the Insights Dojah integration."
}

variable "bucket_names" {
  description = "Bucket names."
  type = list(string)
}

variable "insights_consumer_s3_bucket_names" {
  description = "Bucket names for the Insights Consumer platform."
  type = list(string)
}

variable "mono_integration_bucket_names" {
  description = "Bucket names for the Insights Mono Integration."
  type = list(string)
}

variable "dojah_integration_bucket_names" {
  description = "Bucket names for the Insights Dojah Integration."
  type = list(string)
}

variable "bucket_enc_key_deletion_in_days" {
  description = "How often should the encryption key be rotated"
  type = number
  default = 10
}

variable "bucket_enc_key_rotation_enabled" {
  description = "How often should the encryption key be rotated"
  type = bool
  default = true
}

variable "s3_bucket_pdf_force_destroy" {
  type = bool
  default = true
}
