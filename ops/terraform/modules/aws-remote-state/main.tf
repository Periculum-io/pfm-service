resource "aws_kms_key" "bucket_kms_key" {
  description             = "Key to encrypt bucket objects"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_alias" "bucket_kms_key_alias" {
  name          = var.bucket_enc_key_alias
  target_key_id = aws_kms_key.bucket_kms_key.key_id
}

resource "aws_s3_bucket" "tf_state_s3_bucket" {
  bucket = var.bucket_name
  acl    = var.acl

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.tf_state_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Resource-2: Random String
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