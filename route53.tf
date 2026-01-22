resource "aws_route53_zone" "sandbox_zone" {
  name = "ghanshyam.site"
  vpc {
    vpc_id = aws_vpc.sandbox_vpc.id
  }
  tags = merge(
    {
      Name = "sandbox-poc-route53-zone"
    },
    local.tags
  )
  depends_on = [aws_vpc.sandbox_vpc]
}

resource "aws_route53_health_check" "sandbox_health_check" {
  type                    = "CLOUDWATCH_METRIC"
  cloudwatch_alarm_name   = aws_cloudwatch_metric_alarm.sandbox_alarm.alarm_name
  cloudwatch_alarm_region = var.aws_region
  tags = merge(
    {
      Name = "sandbox-poc-route53-health-check"
    },
    local.tags
  )

}
