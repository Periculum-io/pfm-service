variable "secrets_manager_vm_github_personal_access_token_arn" {
  description = "The secret that contains github email and personal access token so that terraform can setup new vms"
  type = string
  default = null
}