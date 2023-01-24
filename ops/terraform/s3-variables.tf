variable "buckets_count" {
  type = number
  description = "How many buckets should be created."
}

variable "bucket_names" {
  description = "Bucket names."
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