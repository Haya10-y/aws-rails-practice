resource "aws_security_group" "rds" {
  name        = "aws-rails-test-rds-sg"
  description = "aws-rails-test-rds-sg"
  vpc_id      = aws_vpc.aws-rails-test.id

  ingress = [
    {
      description = "default-mysql-port"
      cidr_blocks = []
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.ecs.id]
      self = false
    }
  ]
  egress  = [
    {
      description = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "elasticache" {
  name        = "aws-rails-test-elasticache-sg"
  description = "aws-rails-test-elasticache-sg"
  vpc_id      = aws_vpc.aws-rails-test.id

  ingress = [
    {
      description = "Allow only ECS security group for Redis port"
      cidr_blocks = []
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.ecs.id]
      self = false
    }
  ]
  egress  = [
    {
      description = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "alb" {
  name        = "aws-rails-test-alb-sg"
  description = "aws-rails-test-alb-sg"
  vpc_id      = aws_vpc.aws-rails-test.id

  ingress = [
    {
      description = "Allow all HTTP traffic"
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 80
      to_port = 80
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      description = "Allow all HTTPS traffic"
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 443
      to_port = 443
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
  egress  = [
    {
      description = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_security_group" "ecs-exec" {
  name        = "ecs-exec-sg"
  description = "allow ecs exec"
  vpc_id      = aws_vpc.aws-rails-test.id

  ingress = [
    {
      description = "Allow all HTTPS traffic"
      cidr_blocks = []
      from_port = 443
      to_port = 443
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.ecs.id]
      self = false
    }
  ]
  egress  = [
    {
      description = "Allow all outbound traffic"
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 0
      to_port = 0
      protocol = "-1"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}

resource "aws_security_group" "ecs" {
  name        = "aws-rails-test-ecs-sg"
  description = "aws-rails-test-ecs-sg"
  vpc_id      = aws_vpc.aws-rails-test.id

  ingress = [
    {
      description = "default-rails-port"
      cidr_blocks = ["0.0.0.0/0"]
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
  egress  = [
    {
      description = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
