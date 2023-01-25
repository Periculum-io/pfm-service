resource "aws_kms_key" "kms_key_for_s3_bucket" {
  count                   = var.buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.bucket_names[count.index]}"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_s3_bucket_insights_mobile_sdk_data" {
  count                   = var.buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-insights-mobile-sdk-data"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_s3_insights_consumer_bucket" {
  count                   = var.insights_consumer_s3_buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_s3_mono_integration_bucket" {
  count                   = var.mono_integration_buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_key" "kms_key_for_s3_dojah_integration_bucket" {
  count                   = var.dojah_integration_buckets_count
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}"
  deletion_window_in_days = var.bucket_enc_key_deletion_in_days
  enable_key_rotation     = var.bucket_enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = var.buckets_count
  name          = "alias/${local.resource_name_prefix}-${var.bucket_names[count.index]}-key"
  target_key_id = aws_kms_key.kms_key_for_s3_bucket[count.index].key_id
}

resource "aws_kms_alias" "kms_key_alias_mobile_insights" {
  count         = var.buckets_count
  name          = "alias/${local.resource_name_prefix}-insights-mobile-sdk-data-key"
  target_key_id = aws_kms_key.kms_key_for_s3_bucket_insights_mobile_sdk_data[count.index].key_id
}

resource "aws_kms_alias" "kms_key_insights_consumer_alias" {
  count         = var.insights_consumer_s3_buckets_count
  name          = "alias/${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}-key"
  target_key_id = aws_kms_key.kms_key_for_s3_insights_consumer_bucket[count.index].key_id
}

resource "aws_kms_alias" "kms_key_mono_integration_alias" {
  count         = var.mono_integration_buckets_count
  name          = "alias/${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}-key"
  target_key_id = aws_kms_key.kms_key_for_s3_mono_integration_bucket[count.index].key_id
}

resource "aws_kms_alias" "kms_key_dojah_integration_alias" {
  count         = var.dojah_integration_buckets_count
  name          = "alias/${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}-key"
  target_key_id = aws_kms_key.kms_key_for_s3_dojah_integration_bucket[count.index].key_id
}

resource "aws_s3_bucket" "s3_bucket_insights" {
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

resource "aws_s3_bucket" "s3_bucket_insights_mobile_sdk_data" {
  count         = var.buckets_count
  bucket        = "${local.resource_name_prefix}-insights-mobile-sdk-data"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key_for_s3_bucket_insights_mobile_sdk_data[count.index].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_insights_consumer" {
  count         = var.insights_consumer_s3_buckets_count
  bucket        = "${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key_for_s3_insights_consumer_bucket[count.index].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_insights_mono_integration" {
  count         = var.mono_integration_buckets_count
  bucket        = "${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key_for_s3_mono_integration_bucket[count.index].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_insights_dojah_integration" {
  count         = var.dojah_integration_buckets_count
  bucket        = "${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key_for_s3_dojah_integration_bucket[count.index].arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_insights" {
  count  = var.buckets_count
  bucket = aws_s3_bucket.s3_bucket_insights[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_insights_mobile_sdk_data" {
  count  = var.buckets_count
  bucket = aws_s3_bucket.s3_bucket_insights_mobile_sdk_data[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_insights_consumer_bucket_public_access_block_insights" {
  count  = var.insights_consumer_s3_buckets_count
  bucket = aws_s3_bucket.s3_bucket_insights_consumer[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_mono_integration_bucket_public_access_block_insights" {
  count  = var.mono_integration_buckets_count
  bucket = aws_s3_bucket.s3_bucket_insights_mono_integration[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_dojah_integration_bucket_public_access_block_insights" {
  count  = var.dojah_integration_buckets_count
  bucket = aws_s3_bucket.s3_bucket_insights_dojah_integration[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## S3 bucket access
resource "aws_iam_user" "iam_user_insights_s3_bucket" {
  count = var.buckets_count
  name  = "${local.resource_name_prefix}-${var.bucket_names[count.index]}-user"
}

resource "aws_iam_user" "iam_user_insights_consumer_s3_bucket" {
  count = var.insights_consumer_s3_buckets_count
  name  = "${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}-user"
}

resource "aws_iam_user" "iam_user_insights_mono_integration_s3_bucket" {
  count = var.mono_integration_buckets_count
  name  = "${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}-user"
}

resource "aws_iam_user" "iam_user_insights_dojah_integration_s3_bucket" {
  count = var.dojah_integration_buckets_count
  name  = "${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}-user"
}

resource "aws_iam_access_key" "iam_access_key_s3_bucket" {
  count = var.buckets_count
  user  = aws_iam_user.iam_user_insights_s3_bucket[count.index].name
}

resource "aws_iam_access_key" "iam_access_key_s3_insights_consumer_bucket" {
  count = var.insights_consumer_s3_buckets_count
  user  = aws_iam_user.iam_user_insights_consumer_s3_bucket[count.index].name
}

resource "aws_iam_access_key" "iam_access_key_s3_mono_integration_bucket" {
  count = var.mono_integration_buckets_count
  user  = aws_iam_user.iam_user_insights_mono_integration_s3_bucket[count.index].name
}

resource "aws_iam_access_key" "iam_access_key_s3_dojah_integration_bucket" {
  count = var.dojah_integration_buckets_count
  user  = aws_iam_user.iam_user_insights_dojah_integration_s3_bucket[count.index].name
}

resource "aws_iam_policy" "iam_policy_s3_bucket" {
  count       = var.buckets_count
  name        = "${local.resource_name_prefix}-${var.bucket_names[count.index]}-all"
  path        = "/"
  description = "A specific policy to control and restrict access to ${local.resource_name_prefix}-${var.bucket_names[count.index]}"

  policy      = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":  [
          "s3:ListBucket"
        ],
        "Resource": [
          aws_s3_bucket.s3_bucket_insights[count.index].arn,
          "${aws_s3_bucket.s3_bucket_insights[count.index].arn}/*",
          aws_s3_bucket.s3_bucket_insights_mobile_sdk_data[count.index].arn,
          "${aws_s3_bucket.s3_bucket_insights_mobile_sdk_data[count.index].arn}/*"
        ]
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:PutObject",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource": "${aws_s3_bucket.s3_bucket_insights[count.index].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:PutObject",
        ],
        "Resource": "${aws_s3_bucket.s3_bucket_insights_mobile_sdk_data[count.index].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action": [
          "kms:*"
        ]
        "Resource": [
          aws_kms_key.kms_key_for_s3_bucket[count.index].arn,
          aws_kms_key.kms_key_for_s3_bucket_insights_mobile_sdk_data[count.index].arn
        ]
      },
      {
        "Effect":"Allow",
        "Action": [
          "textract:StartDocumentTextDetection",
          "textract:GetDocumentTextDetection"
        ]
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_s3_insights_consumer_bucket" {
  count       = var.insights_consumer_s3_buckets_count
  name        = "${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}-all"
  path        = "/"
  description = "A specific policy to control and restrict access to ${local.resource_name_prefix}-${var.insights_consumer_s3_bucket_names[count.index]}"

  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":  [
          "s3:ListBucket"
        ],
        "Resource": [
          aws_s3_bucket.s3_bucket_insights_consumer[count.index].arn,
          "${aws_s3_bucket.s3_bucket_insights_consumer[count.index].arn}/*"
        ]
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource": "${aws_s3_bucket.s3_bucket_insights_consumer[count.index].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action": [
          "kms:*"
        ]
        "Resource": aws_kms_key.kms_key_for_s3_insights_consumer_bucket[count.index].arn
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_s3_mono_integration_bucket" {
  count       = var.mono_integration_buckets_count
  name        = "${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}-all"
  path        = "/"
  description = "A specific policy to control and restrict access to ${local.resource_name_prefix}-${var.mono_integration_bucket_names[count.index]}"

  policy      = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":  [
          "s3:ListBucket"
        ],
        "Resource": [
          aws_s3_bucket.s3_bucket_insights_mono_integration[count.index].arn,
          "${aws_s3_bucket.s3_bucket_insights_mono_integration[count.index].arn}/*"
        ]
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:GetObject",
        ],
        "Resource": "${aws_s3_bucket.s3_bucket_insights_mono_integration[count.index].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action": [
          "kms:*"
        ]
        "Resource": aws_kms_key.kms_key_for_s3_mono_integration_bucket[count.index].arn
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_s3_dojah_integration_bucket" {
  count       = var.dojah_integration_buckets_count
  name        = "${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}-all"
  path        = "/"
  description = "A specific policy to control and restrict access to ${local.resource_name_prefix}-${var.dojah_integration_bucket_names[count.index]}"

  policy      = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":  [
          "s3:ListBucket"
        ],
        "Resource": [
          aws_s3_bucket.s3_bucket_insights_dojah_integration[count.index].arn,
          "${aws_s3_bucket.s3_bucket_insights_dojah_integration[count.index].arn}/*"
        ]
      },
      {
        "Effect":"Allow",
        "Action":[
          "s3:GetObject",
        ],
        "Resource": "${aws_s3_bucket.s3_bucket_insights_dojah_integration[count.index].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action": [
          "kms:*"
        ]
        "Resource": aws_kms_key.kms_key_for_s3_dojah_integration_bucket[count.index].arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment_insights_s3_bucket" {
  count      = var.buckets_count
  user       = aws_iam_user.iam_user_insights_s3_bucket[count.index].name
  policy_arn = aws_iam_policy.iam_policy_s3_bucket[count.index].arn
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment_insights_consumer_s3_bucket" {
  count      = var.insights_consumer_s3_buckets_count
  user       = aws_iam_user.iam_user_insights_consumer_s3_bucket[count.index].name
  policy_arn = aws_iam_policy.iam_policy_s3_insights_consumer_bucket[count.index].arn
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment_insights_mono_integration_s3_bucket" {
  count      = var.mono_integration_buckets_count
  user       = aws_iam_user.iam_user_insights_mono_integration_s3_bucket[count.index].name
  policy_arn = aws_iam_policy.iam_policy_s3_mono_integration_bucket[count.index].arn
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment_insights_dojah_integration_s3_bucket" {
  count      = var.dojah_integration_buckets_count
  user       = aws_iam_user.iam_user_insights_dojah_integration_s3_bucket[count.index].name
  policy_arn = aws_iam_policy.iam_policy_s3_dojah_integration_bucket[count.index].arn
}