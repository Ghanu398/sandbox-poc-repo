resource "aws_route53_zone" "sandbox_zone" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  name  = "ghanshyam.site"
  vpc {
    vpc_id     = aws_vpc.sandbox_vpc.id
    vpc_region = var.aws_region
  }
  vpc {
    vpc_id     = one(data.aws_vpc.us-east-1_sandox_vpc[*].id)
    vpc_region = "us-east-1"
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
  count                   = var.aws_region == "us-east-2" ? 1 : 0
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

resource "aws_route53_record" "failover" {
  count   = var.aws_region == "us-east-2" ? 1 : 0
  zone_id = one(aws_route53_zone.sandbox_zone[*].zone_id)
  name    = "failover.ghanshyam.site"
  type    = "A"

  set_identifier  = "Primary"
  health_check_id = one(aws_route53_health_check.sandbox_health_check[*].id)
  alias {
    evaluate_target_health = true
    zone_id                = one(data.aws_lb.sandbox_lb[*].zone_id)
    name                   = one(data.aws_lb.sandbox_lb[*].dns_name)

  }
  failover_routing_policy {
    type = "PRIMARY"


  }
}

resource "aws_route53_record" "failover_routing_policy" {
  count          = var.aws_region == "us-east-2" ? 1 : 0
  zone_id        = one(aws_route53_zone.sandbox_zone[*].zone_id)
  name           = "failover.ghanshyam.site"
  type           = "A"
  set_identifier = "Secondary"
  alias {
    evaluate_target_health = true
    zone_id                = aws_lb.sandbox_lb.zone_id
    name                   = aws_lb.sandbox_lb.dns_name

  }
  failover_routing_policy {
    type = "SECONDARY"
  }
}
