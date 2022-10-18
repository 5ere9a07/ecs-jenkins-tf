data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_peering_connection" "def-ecs" {
  peer_vpc_id = module.vpc.vpc_id
  vpc_id      = data.aws_vpc.default.id
  auto_accept = true
  tags        = local.tags
}

resource "aws_route" "public_internet_gateway12" {
  route_table_id         = module.vpc.private_route_table_ids[0]
  destination_cidr_block = data.aws_vpc.default.cidr_block
  gateway_id             = aws_vpc_peering_connection.def-ecs.id
  depends_on             = [module.vpc, aws_vpc_peering_connection.def-ecs]
}

resource "aws_route" "public_internet_gateway21" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = local.cidr_block
  gateway_id             = aws_vpc_peering_connection.def-ecs.id
  depends_on             = [aws_vpc_peering_connection.def-ecs]
}