variable "dynamodb_table_name" {
  description = "Name of the table that serves as a lock to prevent multiple users write into tf.state file"
  type        = string
  default     = "terraform-state"
}

variable "dynamodb_table_read_capacity" {
  description = "The number of read units for this table"
  type        = number
  default     = 20
}

variable "dynamodb_table_write_capacity" {
  description = "The number of write units for this table"
  type        = number
  default     = 20
}