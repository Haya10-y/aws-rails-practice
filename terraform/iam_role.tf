resource "aws_iam_role" "ecs-task-execution" {
  provider = aws
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2008-10-17"
  })
  description           = "Allows ECS services to execute tasks."
  max_session_duration  = 3600
  name                  = "ecsTaskExecutionRole"
  path                  = "/"
}

resource "aws_iam_role" "secret-values" {
  provider = aws
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = "Allows ECS tasks to call AWS services on your behalf."
  max_session_duration  = 3600
  name                  = "get-secret-values-for-ecs"
  path                  = "/"
}

resource "aws_iam_role" "oidc" {
  provider = aws
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:Haya10-y/aws-rails-practice:ref:refs/heads/production"
        }
      }
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github-actions.arn
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = "Allows GitHub Actions OIDC."
  max_session_duration  = 3600
  name                  = "github-actions-oidc-test"
  path                  = "/"
}

resource "aws_iam_role" "rds-monitoring" {
  provider = aws
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = "Allows monitoring RDS."
  max_session_duration  = 3600
  name                  = "rds-monitoring-role"
  path                  = "/"
}
