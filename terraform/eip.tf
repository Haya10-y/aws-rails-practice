resource "aws_eip" "nat" {
  tags = {
    Name = "aws-rails-test-nat-eip"
  }
}
