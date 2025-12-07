resource "aws_ecs_cluster" "rails-test" {
  name = "aws-rails-test-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "rails-test" {
  cluster_name = aws_ecs_cluster.rails-test.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "rails-test" {
  family                   = "aws-rails-test-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs-task-execution.arn
  task_role_arn      = aws_iam_role.secret-values.arn

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = "416000664814.dkr.ecr.ap-northeast-1.amazonaws.com/aws-rails-test:latest"
      essential = true

      portMappings = [
        {
          name = "rails-default-port"
          appProtocol = "http"
          hostPort = 3000
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "AWS_REGION"
          value = "ap-northeast-1"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        },
        {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "1"
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        }
      ]

      secrets = [
        {
          name = "APP_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:APP_HOST::"
        },
        {
          name = "AWS_ACCESS_KEY_ID"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:AWS_ACCESS_KEY_ID::"
        },
        {
          name = "AWS_SECRET_ACCESS_KEY"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:AWS_SECRET_ACCESS_KEY::"
        },
        {
          name = "MYSQL_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:MYSQL_HOST::"
        },
        {
          name = "RAILS_MASTER_KEY"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:RAILS_MASTER_KEY::"
        },
        {
          name = "REDIS_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:REDIS_HOST::"
        },
        {
          name = "REDIS_URL"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:REDIS_URL::"
        },
        {
          name = "S3_BUCKET"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:S3_BUCKET::"
        },
        {
          name = "SENDER_ADDRESS"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SENDER_ADDRESS::"
        },
        {
          name = "SMTP_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_HOST::"
        },
        {
          name = "SMTP_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_USERNAME::"
        },
        {
          name = "SMTP_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_PASSWORD::"
        },
        {
          name = "WEBAPP_DATABASE_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:WEBAPP_DATABASE_PASSWORD::"
        }
      ]

      environmentFiles = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group = "true"
          awslogs-group = "/ecs/aws-rails-test-task-def"
          awslogs-region = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      mountPoints = []

      systemControls = []
      ulimits = []
      volumesFrom = []
    },
    {
      name = "worker"
      command = ["bundle", "exec", "sidekiq"]
      portMappings = []
      essential = false
      image = "416000664814.dkr.ecr.ap-northeast-1.amazonaws.com/aws-rails-test:latest"

      environment = [
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "AWS_REGION"
          value = "ap-northeast-1"
        },
        {
          name  = "RAILS_LOG_TO_STDOUT"
          value = "1"
        },
        {
          name  = "RAILS_SERVE_STATIC_FILES"
          value = "1"
        },
        {
          name  = "REDIS_PORT"
          value = "6379"
        }
      ]

      secrets = [
        {
          name = "APP_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:APP_HOST::"
        },
        {
          name = "AWS_ACCESS_KEY_ID"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:AWS_ACCESS_KEY_ID::"
        },
        {
          name = "AWS_SECRET_ACCESS_KEY"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:AWS_SECRET_ACCESS_KEY::"
        },
        {
          name = "MYSQL_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:MYSQL_HOST::"
        },
        {
          name = "RAILS_MASTER_KEY"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:RAILS_MASTER_KEY::"
        },
        {
          name = "REDIS_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:REDIS_HOST::"
        },
        {
          name = "REDIS_URL"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:REDIS_URL::"
        },
        {
          name = "S3_BUCKET"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:S3_BUCKET::"
        },
        {
          name = "SENDER_ADDRESS"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SENDER_ADDRESS::"
        },
        {
          name = "SMTP_HOST"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_HOST::"
        },
        {
          name = "SMTP_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_USERNAME::"
        },
        {
          name = "SMTP_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:SMTP_PASSWORD::"
        },
        {
          name = "WEBAPP_DATABASE_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.rails-test.arn}:WEBAPP_DATABASE_PASSWORD::"
        }
      ]

      environmentFiles = []

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group = "true"
          awslogs-group = "/ecs/aws-rails-test-task-def"
          awslogs-region = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      mountPoints = []

      systemControls = []
      volumesFrom = []
    }
  ])
}
