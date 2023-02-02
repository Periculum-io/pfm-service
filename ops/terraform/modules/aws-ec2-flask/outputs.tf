output "instance_1_host_address" {
  value = aws_instance.ec2_api_instance.public_dns
}

output "github_username" {
  value = local.github_info.username
  sensitive = true
}

output "github_personal_access_token" {
  value = local.github_info.personal_access_token
  sensitive = true
}