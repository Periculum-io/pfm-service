resource "random_string" "dynamodb_table_random_suffix" {
  length = 4
  upper = false
  special = false
}

resource "aws_dynamodb_table" "tf_state_lock" {
  name           = "${var.dynamodb_table_name}-${random_string.dynamodb_table_random_suffix.id}"
  read_capacity  = var.dynamodb_table_read_capacity
  write_capacity = var.dynamodb_table_read_capacity
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}