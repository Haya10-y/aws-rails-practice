resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.aws-rails-test.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-rails-test-subnet-public1-ap-northeast-1a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.aws-rails-test.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-rails-test-subnet-public2-ap-northeast-1c"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.aws-rails-test.id
  cidr_block              = "10.0.21.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-rails-test-subnet-private1-ap-northeast-1a"
  }
}


resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.aws-rails-test.id
  cidr_block              = "10.0.22.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-rails-test-subnet-private2-ap-northeast-1c"
  }
}
