resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-rails-test.id
}

resource "aws_route" "private_a_default" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws-rails-test.id
}

resource "aws_route" "private_c_default" {
  route_table_id         = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws-rails-test.id
}

# ERROR: あらかじめ指定されている vpc_endpoint_id だと動かない模様。
#        一旦 gateway_id で置くが、だいぶ怖い…
resource "aws_route" "private_a_s3" {
  route_table_id         = aws_route_table.private_a.id
  gateway_id        = aws_vpc_endpoint.s3.id
  destination_prefix_list_id = "pl-61a54008"
}

resource "aws_route" "private_c_s3" {
  route_table_id         = aws_route_table.private_c.id
  gateway_id        = aws_vpc_endpoint.s3.id
  destination_prefix_list_id = "pl-61a54008"
}
