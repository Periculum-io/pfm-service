variable "aws_region" {
  description = "Region in which AWS resources will be created"
  type = string
  default = "us-east-1"
}

variable "ecr_repository_mutable" {
  description = "If tags on images in the repository should be mutable"
  type = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates if pushed image should be scanned by AWS"
  type = bool
  default = "false"
}

variable "ecr_repository_name" {
  description = "Name of ECR repository"
  type = list(string)
  default = [ "pfm-admin-frontend", "pfm-admin-api"]
}