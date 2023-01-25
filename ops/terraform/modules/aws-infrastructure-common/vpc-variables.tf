variable "vpc_public_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for public subnets"
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "vpc_private_subnets_cidr" {
  type = list(string)
  description = "List of CIDR ranges for private subnets"
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  type = list(string)
  description = "List of availability zones"
  default = ["us-east-1a", "us-east-1b"]
}