resource "aws_cloudwatch_metric_alarm" "sandbox_alarm" {
  alarm_name          = "sandbox-poc-alarm-${var.aws_region}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "status"
  namespace           = "custom-metrics"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "This metric monitors EC2 custom metrics and triggers an alarm if status is 0 (unhealthy)."
  actions_enabled     = true
  tags = merge(
    {
      Name = "sandbox-poc-cloudwatch-alarm-${var.aws_region}"
    },
    local.tags
  )
}
