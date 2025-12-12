resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.aws-rails-test.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]

  security_group_ids = [
    aws_security_group.ecs-exec.id
  ]

  tags = {
    Name = "ecs-exec-endpoint-ssm"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.aws-rails-test.id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]

  security_group_ids = [
    aws_security_group.ecs-exec.id
  ]

  tags = {
    Name = "ecs-exec-endpoint-ssmmessages"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.aws-rails-test.id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]

  security_group_ids = [
    aws_security_group.ecs-exec.id
  ]

  tags = {
    Name = "ecs-exec-endpoint-ec2messages"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.aws-rails-test.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_c.id
  ]

  tags = {
    Name = "aws-rails-test-vpce-s3"
  }
}
