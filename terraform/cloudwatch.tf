resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/aws-rails-test-task-def"
  retention_in_days = 0 # 本番環境では 14 などの値にすること
}
