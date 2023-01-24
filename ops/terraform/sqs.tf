resource "aws_kms_key" "kms_key_for_sqs" {
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.sqs_queue_name}"
  deletion_window_in_days = var.sqs_enc_key_deletion_in_days
  enable_key_rotation     = var.sqs_enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias_sqs" {
  name          = "alias/${local.resource_name_prefix}-${var.sqs_queue_name}-key"
  target_key_id = aws_kms_key.kms_key_for_sqs.key_id
}

resource "aws_kms_key" "kms_key_for_sqs_dlq" {
  description             = "Key to encrypt objects in ${local.resource_name_prefix}-${var.sqs_queue_name}-dlq"
  deletion_window_in_days = var.sqs_enc_key_deletion_in_days
  enable_key_rotation     = var.sqs_enc_key_rotation_enabled
}

resource "aws_kms_alias" "kms_key_alias_sqs_dlq" {
  name          = "alias/${local.resource_name_prefix}-${var.sqs_queue_name}-dlq-key"
  target_key_id = aws_kms_key.kms_key_for_sqs_dlq.key_id
}

resource "aws_sqs_queue" "sqs_queue_pdf_processing_dlq" {
  name       = "${local.resource_name_prefix}-${var.sqs_queue_name}-dlq${var.sqs_fifo_queue ? ".fifo" : ""}"
  fifo_queue = var.sqs_fifo_queue

  kms_master_key_id = aws_kms_key.kms_key_for_sqs_dlq.arn

  max_message_size          = var.sqs_max_message_size
  message_retention_seconds = var.sqs_message_retention_seconds
  receive_wait_time_seconds = var.sqs_receive_wait_time_seconds
}

resource "aws_sqs_queue" "sqs_queue_pdf_processing" {
  name       = "${local.resource_name_prefix}-${var.sqs_queue_name}"
  fifo_queue = var.sqs_fifo_queue

  kms_master_key_id = aws_kms_key.kms_key_for_sqs.arn

  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_pdf_processing_dlq.arn
    maxReceiveCount     = var.sqs_max_receive_count
  })
}