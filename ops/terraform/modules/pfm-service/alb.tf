resource "aws_alb_target_group" "keycloak_alb_target_group" {
  name        = "${var.application_short_name}-tg"
  port        = var.alb_target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.application_short_name}-target-group"
  }
}

resource "aws_lb_target_group_attachment" "keycloak_alb_target_group_instance_1_attachment" {
  target_group_arn  = aws_alb_target_group.keycloak_alb_target_group.arn
  target_id         = aws_instance.keycloak_instance.id
  port              = 80
}