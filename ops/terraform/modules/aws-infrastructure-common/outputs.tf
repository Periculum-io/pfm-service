output "alb_id" {
  value = aws_alb.alb_pfm.id
}

output "alb_domain" {
  value = aws_alb.alb_pfm.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.security_group_pfm_alb.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.cloudwatch_log_group_pfm.name
}

output "logs_s3_bucket_alb_id" {
  value = aws_s3_bucket.s3_bucket_logs.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "aws_alb_security_group_id" {
  value = aws_security_group.security_group_pfm_alb.id
}
