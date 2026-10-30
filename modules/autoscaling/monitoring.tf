# Monitor average CPU utilization across the Auto Scaling Group
resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "${var.project_name}-asg-high-cpu"
  alarm_description   = "Triggers when average ASG CPU utilization exceeds 70%"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 300
  statistic          = "Average"
  threshold          = 70
  alarm_actions      = [aws_sns_topic.asg_alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  treat_missing_data = "notBreaching"
}