resource "aws_nat_gateway" "aws-rails-test" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "aws-rails-test-nat-gateway"
  }
}
