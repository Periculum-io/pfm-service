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

variable "vpc_pfm_public_subnets" {
  description = "The public subnet ids of the insights vpc"
  default     = null
  type        = list(string)
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

variable "ec2_prod_insights_private_subnet_us_east_1a" {
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

variable "bucket_names" {
  description = "Bucket names."
  type = list(string)
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
