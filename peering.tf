resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = aws_vpc.main.id 
  vpc_id        = data.aws_vpc.default.id #requester
  auto_accept   = true

  tags = {
    Name = "VPC Peering between expense and default"
  }
}

# count is useful to control when resource is required
resource "aws_route" "public_peering" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "private_peering" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "default_peering" {
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}