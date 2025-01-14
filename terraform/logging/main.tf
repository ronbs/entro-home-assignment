# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group_name
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.log_group.name
}