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
