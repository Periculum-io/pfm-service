variable "rds_username" {
  description = "The PFM DB username"
  type = string
  default = null
}

variable "ec2_instance_type" {
  description = "The type of the ec2 instance"
  default     = "t3.micro"
  type        = string
}

variable "ec2_ami_id" {
  description = "The id of the AMI to use for the ubuntun instances"
  default     = "ami-052efd3df9dad4825"
  type        = string
}

variable "ec2_insights_private_subnet_us_east_1a" {
  description = "The private subnet to launch all ec2 instances in"
  default     = null
  type        = string
}

variable "ec2_ssh_private_key_secret_name" {
  description = "The Private key used to ssh into ec2 instance that host the pfm flask api"
  default     = null
  type        = string
}

variable "ec2_ssh_public_key_secret_name" {
  description = "Public key used for ssh authentication for ec2 instances that host the pfm flask api."
  default     = null
  type        = string
}

variable "ec2_lb_domain_name" {
  description = "The flask server domain" 
  type        = string
}

variable "ec2_lb_hosted_zone_domain" {
  description = "The EC2 hosted domain zone" 
  type        = string
}

variable "bucket_names" {
  description = "Bucket names."
  type = list(string)
}

variable "pfm_aws_db_subnet_group" {  
  description = "The database subnet group"
  type = string
}

variable "rds_allocated_storage" {
  type = number
  description = "Initial allocated storage in gigabytes."
}

variable "rds_max_allocated_storage" {
  type = number
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "rds_instance_class" {
  type = string
  description = "The instance type of the RDS instance."
}

variable "rds_availability_zone" {
  type = string
}

variable "rds_backup_retention_period" {
  type = number
  description = "The days to retain backups for."
}

variable "rds_multi_az_enabled" {
  type = bool
  default = false
}

variable "rds_allow_minor_version_upgrade" {
  type = bool
  description = "Indicates that minor version upgrades are allowed"
  default = true
}

variable "rds_cloudwatch_logs_exports" {
  type = set(string)
  description = "Set of log types to enable for exporting to CloudWatch logs."   
}

variable "rds_kms_key_alias_names_pfm" {
  type = list(string)
  description = "Name of keys that will be used for encryption of rds and performance for pdf processing."   
}

variable "secrets_manager_vm_github_personal_access_token_arn" {
  description = "The secret github personal access token"
  default     = null
  type        = string
}

