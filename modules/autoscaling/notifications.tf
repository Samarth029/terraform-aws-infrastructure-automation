# SNS topic for Auto Scaling CloudWatch alarm notifications
resource "aws_sns_topic" "asg_alerts" {
  name = "${var.project_name}-asg-alerts"

  tags = {
    Name    = "${var.project_name}-asg-alerts"
    Project = var.project_name
  }
}

# Email subscription for CloudWatch alarm notifications
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.asg_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}