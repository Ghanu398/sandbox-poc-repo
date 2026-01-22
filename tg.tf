resource "aws_lb_target_group" "tg" {
  name        = "sandbox-poc-tg-${var.aws_region}"
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 20
    enabled             = true
    matcher             = "200"
  }
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.sandbox_vpc.id
  depends_on = [aws_instance.server]
  tags = merge(
    {
      Name = "sandbox-poc-tg-${var.aws_region}"
    },
    local.tags
  )
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each         = { for k, i in aws_instance.server : k => i.id if strcontains(i.tags["Name"], "private") }
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
}
