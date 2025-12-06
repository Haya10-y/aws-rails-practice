resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-rails-test.id

  tags = {
    Name = "aws-rails-test-rtb-public"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.aws-rails-test.id

  tags = {
    Name = "aws-rails-test-rtb-private1-ap-northeast-1a"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.aws-rails-test.id

  tags = {
    Name = "aws-rails-test-rtb-private2-ap-northeast-1c"
  }
}
