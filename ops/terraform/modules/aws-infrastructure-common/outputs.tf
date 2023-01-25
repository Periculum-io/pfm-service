output "alb_id" {
  value = aws_alb.alb_insights.id
}

output "alb_domain" {
  value = aws_alb.alb_insights.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.security_group_insights_alb.id
}

output "vpc_id" {
  value = aws_vpc.insights_vpc.id
}

output "subnet_private_ids" {
  value = aws_subnet.insights_private_subnet.*.id
}

output "subnet_public_ids" {
  value = aws_subnet.insights_public_subnet.*.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudwatch_log_group_insights.name
}

output "logs_s3_bucket_alb_id" {
  value = aws_s3_bucket.s3_bucket_insights_logs.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "s3_buckets_arn" {
  value = aws_s3_bucket.s3_bucket_insights[*].arn
}

output "s3_insights_consumer_buckets_arn" {
  value = aws_s3_bucket.s3_bucket_insights_consumer[*].arn
}

output "s3_mono_integration_buckets_arn" {
  value = aws_s3_bucket.s3_bucket_insights_mono_integration[*].arn
}

output "s3_dojah_integration_buckets_arn" {
  value = aws_s3_bucket.s3_bucket_insights_dojah_integration[*].arn
}
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket_insights[*].bucket
}

output "s3_insights_consumer_bucket_name" {
  value = aws_s3_bucket.s3_bucket_insights_consumer[*].bucket
}

output "s3_mono_integration_bucket_name" {
  value = aws_s3_bucket.s3_bucket_insights_mono_integration[*].bucket
}

output "s3_dojah_integration_bucket_name" {
  value = aws_s3_bucket.s3_bucket_insights_dojah_integration[*].bucket
}
output "s3_bucket_kms_key_arn" {
  value = aws_kms_key.kms_key_for_s3_bucket[*].arn
}

output "s3_mono_integration_bucket_kms_key_arn" {
  value = aws_kms_key.kms_key_for_s3_mono_integration_bucket[*].arn
}

output "s3_dojah_integration_bucket_kms_key_arn" {
  value = aws_kms_key.kms_key_for_s3_dojah_integration_bucket[*].arn
}
output "s3_insights_consumer_bucket_kms_key_arn" {
  value = aws_kms_key.kms_key_for_s3_insights_consumer_bucket[*].arn
}

output "s3_bucket_iam_access_key_id" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_bucket[*].id
}

output "s3_insights_consumer_bucket_iam_access_key_id" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_insights_consumer_bucket[*].id
}

output "s3_mono_integration_bucket_iam_access_key_id" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_mono_integration_bucket[*].id
}

output "s3_dojah_integration_bucket_iam_access_key_id" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_dojah_integration_bucket[*].id
}

output "s3_bucket_iam_access_key_secret" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_bucket[*].secret
}

output "s3_insights_consumer_bucket_iam_access_key_secret" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_insights_consumer_bucket[*].secret
}

output "s3_mono_integration_bucket_iam_access_key_secret" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_mono_integration_bucket[*].secret
}

output "s3_dojah_integration_bucket_iam_access_key_secret" {
  sensitive = true
  value = aws_iam_access_key.iam_access_key_s3_dojah_integration_bucket[*].secret
}

output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue_insights.url
}

output "sqs_queue_url_insights_consumer" {
  value = aws_sqs_queue.sqs_queue_insights_consumer.url
}

output "sqs_queue_url_insights_mono_integration" {
  value = aws_sqs_queue.sqs_queue_insights_mono_integration.url
}

output "sqs_queue_url_insights_dojah_integration" {
  value = aws_sqs_queue.sqs_queue_insights_dojah_integration.url
}
output "sqs_queue_name" {
  value = aws_sqs_queue.sqs_queue_insights.name
}

output "sqs_insights_consumer_queue_name" {
  value = aws_sqs_queue.sqs_queue_insights_consumer.name
}

output "sqs_insights_mono_integration_queue_name" {
  value = aws_sqs_queue.sqs_queue_insights_mono_integration.name
}

output "sqs_insights_dojah_integration_queue_name" {
  value = aws_sqs_queue.sqs_queue_insights_dojah_integration.name
}
output "sqs_queue_arn" {
  value = aws_sqs_queue.sqs_queue_insights.arn
}

output "sqs_queue_arn_insights_consumer" {
  value = aws_sqs_queue.sqs_queue_insights_consumer.arn
}

output "sqs_queue_arn_insights_mono_integration" {
  value = aws_sqs_queue.sqs_queue_insights_mono_integration.arn
}

output "sqs_queue_arn_insights_dojah_integration" {
  value = aws_sqs_queue.sqs_queue_insights_dojah_integration.arn
}
output "sqs_queue_kms_key_arn" {
  value = aws_kms_key.kms_key_for_sqs.arn
}

output "sqs_queue_kms_key_arn_insights_consumer" {
  value = aws_kms_key.kms_key_for_sqs_insights_consumer.arn
}

output "sqs_queue_kms_key_arn_mono_integration" {
  value = aws_kms_key.kms_key_for_sqs_insights_mono_integration.arn
}

output "sqs_queue_kms_key_arn_dojah_integration" {
  value = aws_kms_key.kms_key_for_sqs_insights_dojah_integration.arn
}
output "sqs_queue_deadletter_kms_key_arn" {
  value = aws_kms_key.kms_key_for_sqs_dlq.arn
}

output "sqs_queue_deadletter_kms_key_arn_insights_consumer" {
  value = aws_kms_key.kms_key_for_sqs_dlq_insights_consumer.arn
}

output "sqs_queue_deadletter_kms_key_arn_mono_integration" {
  value = aws_kms_key.kms_key_for_sqs_dlq_insights_mono_integration.arn
}

output "sqs_queue_deadletter_kms_key_arn_dojah_integration" {
  value = aws_kms_key.kms_key_for_sqs_dlq_insights_dojah_integration.arn
}