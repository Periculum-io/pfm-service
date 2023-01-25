output "alb_dns_name" {
  value = aws_alb.keycloak_alb.dns_name
}

# output "alb_public_ip" {
#     value = "${aws_alb.keycloak_alb.public_ip}"
# }

output "alb_id" {
  value = "${aws_alb.keycloak_alb.id}"
}

output "alb_arn" {
  value = aws_alb.keycloak_alb.arn
}

output "alb_zone" {
  value = aws_alb.keycloak_alb.zone_id
}

output "alb_listener_front_end_tls" {
  value = aws_alb_listener.front_end_tls.id
}

output "alb_listener_front_end_arn" {
  value = aws_alb_listener.front_end_tls.arn
}

output "alb_security_group_id" {
  value = aws_security_group.keycloak_alb_sg.id
}