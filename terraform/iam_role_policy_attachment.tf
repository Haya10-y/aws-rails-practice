resource "aws_iam_role_policy_attachment" "secret-values-secret-values" {
  role       = aws_iam_role.secret-values.name
  policy_arn = aws_iam_policy.secret-values.arn
}

resource "aws_iam_role_policy_attachment" "secret-values-ecs-exec" {
  role       = aws_iam_role.secret-values.name
  policy_arn = aws_iam_policy.ecs-exec.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-secret-values" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = aws_iam_policy.secret-values.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-ecs-exec" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = aws_iam_policy.ecs-exec.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "oidc-github-actions" {
  role       = aws_iam_role.oidc.name
  policy_arn = aws_iam_policy.github-actions.arn
}

resource "aws_iam_role_policy_attachment" "oidc-s3-readonly" {
  role       = aws_iam_role.oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "rds-monitoring-role-policy" {
  role       = aws_iam_role.rds-monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
