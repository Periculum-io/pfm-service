output "ecr_repository_url" {
  description = "ECR Repositry URL"
  value = aws_ecr_repository.pfm_repository[*].repository_url
}

output "ecr_registry_id" {
  description = "ECR Registry ID"
  value = aws_ecr_repository.pfm_repository[*].registry_id
}