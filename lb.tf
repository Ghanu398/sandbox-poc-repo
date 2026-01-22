resource "aws_lb" "sandbox_lb" {
  name               = "sandbox-poc-lb-${var.aws_region}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sandbox_sg.id]
  subnets            = local.lb_subnets
  tags = merge(
    {
      Name = "sandbox-poc-lb-${var.aws_region}"
    },
    local.tags
  )
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.sandbox_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

}
