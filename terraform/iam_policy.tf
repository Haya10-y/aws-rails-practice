resource "aws_iam_policy" "ecs-exec" {
  name        = "enable-ecs-exec"

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
    Version = "2012-10-17"
  })
  tags = {}
}

resource "aws_iam_policy" "secret-values" {
  name        = "get-secret-values"

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect = "Allow"
        Resource = aws_secretsmanager_secret.rails-test.arn
      },
    ]
    Version = "2012-10-17"
  })
  tags = {}
}

resource "aws_iam_policy" "s3" {
  name        = "aws-rails-s3"

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObjectAcl",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.rails-test.arn}/*",
          aws_s3_bucket.rails-test.arn,
        ]
        Sid = "VisualEditor0"
      },
    ]
    Version = "2012-10-17"
  })
  tags = {}
}

resource "aws_iam_policy" "github-actions" {
  name        = "ecr-github-actions-test"

  policy = jsonencode({
    Statement = [
      {
        Action = "ecr:GetAuthorizationToken"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:UploadLayerPart",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
        ]
        Effect = "Allow"
        Resource = aws_ecr_repository.rails-test.arn
      }
    ]
    Version = "2012-10-17"
  })
  tags = {}
}
