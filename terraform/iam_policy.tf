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
        Resource = "arn:aws:secretsmanager:ap-northeast-1:416000664814:secret:aws-rails-test-secrets-higJwm"
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
          "arn:aws:s3:::haya10-s3-test-bucket-r03v/*",
          "arn:aws:s3:::haya10-s3-test-bucket-r03v",
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
        Resource = "arn:aws:ecr:ap-northeast-1:416000664814:repository/aws-rails-test"
      }
    ]
    Version = "2012-10-17"
  })
  tags = {}
}
