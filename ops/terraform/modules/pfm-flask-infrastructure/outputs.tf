output "instance_1_host_address" {
  value = aws_instance.pfm_api_instance_1.public_dns
}

output "github_username" {
  value = local.github_info.username
  sensitive = true
}

output "github_personal_access_token" {
  value = local.github_info.personal_access_token
  sensitive = true
}