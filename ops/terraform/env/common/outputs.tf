output "instance_1_host_address" {
  value = module.pfm_flask_api.instance_1_host_address
}

output "ec2_instance_id" {
  value = module.pfm_flask_api.ec2_instance_id
}

output "github_username" {
  value = module.pfm_flask_api.github_username
  sensitive = true
}

output "github_personal_access_token" {
  value = module.pfm_flask_api.github_personal_access_token
  sensitive = true
}