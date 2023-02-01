resource "aws_ecr_repository" "pfm_repository" {
  count                = length(var.ecr_repository_name)
  name                 = var.ecr_repository_name[count.index]
  image_tag_mutability = var.ecr_repository_mutable

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}