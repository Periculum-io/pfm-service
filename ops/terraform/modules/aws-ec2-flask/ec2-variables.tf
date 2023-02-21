variable "environment" {
  description = "Name of the environment"
  type = string
}

variable "resource_name_prefix" {
  description = "Name of the resource_name_prefix"
  type = string
}

variable "aws_region" {
  description = "The AWS region where everything will be deployed"
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  description = "The id of the vpc where all things for this project will be hosted in"
  default     = null
  type        = string
}

variable "vpc_public_subnets" {
  description = "The public subnet ids of the insights vpc"
  default     = null
  type        = list(string)
}

variable "ec2_ami_id" {
  description = "The id of the AMI to use for the ubuntun instances"
  default     = "ami-052efd3df9dad4825"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of the ec2 instance"
  default     = "t3.micro"
  type        = string
}

variable "ec2_insights_private_subnet_us_east_1a" {
  description = "The private subnet to launch all ec2 instances in"
  default     = null
  type        = string
}

variable "ec2_ssh_private_key_secret_name" {
  description = "The secret name that holds the private key"
  default     = null
  type        = string
}

variable "ec2_ssh_public_key_secret_name" {
  description = "The secret name that holds the public key"
  default     = null
  type        = string
}

variable "ec2_keycloak_authority" {
  description = "The keycloak authority"
  type        = string
}

variable "ec2_keycloak_clientsecret" {
  description = "Client Secret for Keycloak authentication"
  type        = string
}

variable "ec2_target_domain_certificate" {
  description = "Domain certificate for Flask Api EC2 Instance"
  type        = string
}

variable "secrets_manager_vm_github_personal_access_token_arn" {
  description = "The secret github personal access token"
  default     = null
  type        = string
}

variable "alb_security_group_id" {
  description = "The security group id of the alb that the ec2 instance relies on"
  default     = null
  type        = string
}