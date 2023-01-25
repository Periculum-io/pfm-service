data "aws_route53_zone" "main" {
  name = var.zone_name
  private_zone = false
}