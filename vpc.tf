resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name = "${var.vpc_tags.Name}-${local.resource_name}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    var.common_tags,
    {
        Name = "${var.igw_tags.Name}-${local.resource_name}"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.public_subnet_tags,
    var.common_tags,
    {
        Name = "${local.resource_name}-${var.public_subnet_tags.Name}-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.private_subnet_tags,
    var.common_tags,
    {
        Name = "${local.resource_name}-${var.private_subnet_tags.Name}-${local.az_names[count.index]}"
    }
  )
}

resource "aws_eip" "eip" {
  domain   = "vpc"

  tags = merge(
    var.eip_tags,
    var.common_tags,
    {
        Name = "${var.eip_tags.Name}-${local.resource_name}"
    }
  )
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.nat_gw_tags,
    var.common_tags,
    {
        Name = "${var.nat_gw_tags.Name}-${local.resource_name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public_route_table_tags,
    var.common_tags,
    {
        Name = "${var.public_route_table_tags.Name}-${local.resource_name}"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private_route_table_tags,
    var.common_tags,
    {
        Name = "${var.private_route_table_tags.Name}-${local.resource_name}"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

