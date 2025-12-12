resource "aws_internet_gateway" "aws-rails-test" {
  vpc_id = aws_vpc.aws-rails-test.id

  tags = {
    Name = "aws-rails-test-igw"
  }
}
