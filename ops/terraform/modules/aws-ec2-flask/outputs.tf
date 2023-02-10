output "instance_1_host_address" {
  value = aws_instance.ec2_api_instance.public_dns
}

output "ec2_instance_id" {
  value = aws_instance.ec2_api_instance.id
}

output "github_username" {
  value = local.github_info.username
  sensitive = true
}

output "github_personal_access_token" {
  value = local.github_info.personal_access_token
  sensitive = true
}

output "ec2_ssh_private_key" {
  value = tls_private_key.genkey.private_key_openssh
  sensitive = true
}