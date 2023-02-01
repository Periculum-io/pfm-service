resource "aws_iam_user" "iam_user_pfm" {
  name  = "${local.resource_name_prefix}-pfm-user"
}

resource "aws_iam_access_key" "iam_access_key" {
  user  = aws_iam_user.iam_user_pfm.name
}

resource "aws_iam_policy" "iam_policy_s3_bucket" {
  name        = "${local.resource_name_prefix}-${var.bucket_names[0]}-all"
  path        = "/"
  description = "A specific policy to control and restrict access to ${local.resource_name_prefix}-${var.bucket_names[0]}"

  policy      = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":  [
          "s3:ListBucket"
        ],
        "Resource": [
          "${aws_s3_bucket.s3_bucket_pfm[0].arn}",
          "${aws_s3_bucket.s3_bucket_pfm[0].arn}/*"
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
        "Resource": "${aws_s3_bucket.s3_bucket_pfm[0].arn}/*"
      },
      {
        "Effect":"Allow",
        "Action": [
          "kms:*"
        ]
        "Resource": [
          aws_kms_key.kms_key_for_s3_bucket[0].arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_secrets_manager_read" {
  name        = "${local.resource_name_prefix}-pfm-retrieves-secretsmanager-secrets"
  path        = "/"
  description = "Allows lambda to receive secrets from secrets manager."

  policy      = jsonencode({
    "Version":"2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": [
            aws_secretsmanager_secret.pfm_admin_api_secret.arn
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachment_s3_bucket" {
  user       = aws_iam_user.iam_user_pfm.name
  policy_arn = aws_iam_policy.iam_policy_s3_bucket.arn
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_secrets_manager_read" {
  user       = aws_iam_user.iam_user_pfm.name
  policy_arn = aws_iam_policy.iam_policy_secrets_manager_read.arn
}