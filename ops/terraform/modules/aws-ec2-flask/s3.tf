resource "aws_kms_key" "kms_key_for_s3_bucket" {
  count                   = var.buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.bucket_names[count.index]}"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = var.buckets_count
  name          = "alias/${local.resource_name_prefix}-${var.bucket_names[count.index]}-key"
  target_key_id = aws_kms_key.kms_key_for_s3_bucket[count.index].key_id
}

resource "aws_s3_bucket" "s3_bucket" {
  count         = var.buckets_count
  bucket        = "${local.resource_name_prefix}-${var.bucket_names[count.index]}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key_for_s3_bucket[count.index].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_pfm" {
  count  = var.buckets_count
  bucket = aws_s3_bucket.s3_bucket[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}