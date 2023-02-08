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

variable "bucket_enc_key_alias" {
  description = "Alias for the encryption key. Must start with 'alias/'"
  type = string
  default = "alias/insights-terraform-backend-bucket-key"
}

variable "bucket_name" {
  description = "Name of s3 bucket"
  type = string
  default = "insights-terraform-backend-bucket"
}

variable "acl" {
  description = "ACL type"
  type = string
  default = "private"
}

variable "dynamodb_table_name" {
  description = "Name of the table that serves as a lock to prevent multiple users write into tf.state file"
  type = string
  default = "terraform-state"
}

variable "dynamodb_table_read_capacity" {
  description = "The number of read units for this table"
  type = number
  default = 20
}

variable "dynamodb_table_write_capacity" {
  description = "The number of write units for this table"
  type = number
  default = 20
}

