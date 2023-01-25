resource "aws_vpc" "insights_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-vpc"
    },
  )
}

resource "aws_internet_gateway" "insights_vpc_internet_gateway" {
  vpc_id = aws_vpc.insights_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-igw"
    },
  )
}

resource "aws_subnet" "insights_public_subnet" {
  vpc_id                  = aws_vpc.insights_vpc.id
  count                   = length(var.vpc_public_subnets_cidr)
  cidr_block              = element(var.vpc_public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-public-subnet-${var.availability_zones[count.index]}"
    },
  )
}

resource "aws_subnet" "insights_private_subnet" {
  vpc_id                  = aws_vpc.insights_vpc.id
  count                   = length(var.vpc_private_subnets_cidr)
  cidr_block              = element(var.vpc_private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-private-subnet-${var.availability_zones[count.index]}"
    },
  )
}

resource "aws_eip" "insights_eip_nat_gateway" {
  count = length(var.availability_zones)

  vpc        = true
  depends_on = [aws_internet_gateway.insights_vpc_internet_gateway]
}

resource "aws_nat_gateway" "insights_nat_gateway" {
  count         = length(aws_eip.insights_eip_nat_gateway)
  allocation_id = aws_eip.insights_eip_nat_gateway[count.index].id
  subnet_id     = aws_subnet.insights_public_subnet[count.index].id
  depends_on    = [aws_internet_gateway.insights_vpc_internet_gateway]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-nat-gateway-${var.availability_zones[count.index]}"
    },
  )
}

resource "aws_route_table" "insights_route_table_public" {
  vpc_id = aws_vpc.insights_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-route-table-public"
    },
  )
}

# Each NAT GW needs to have dedicated routing to ensure AZ grade redundancy
resource "aws_route_table" "insights_route_table_private" {
  count  = length(aws_nat_gateway.insights_nat_gateway)
  vpc_id = aws_vpc.insights_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_name_prefix}-insights-route-table-private-${var.availability_zones[count.index]}"
    },
  )
}

resource "aws_route" "insights_route_public" {
  route_table_id         = aws_route_table.insights_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.insights_vpc_internet_gateway.id
}

resource "aws_route" "insights_route_private" {
  count                  = length(aws_nat_gateway.insights_nat_gateway)
  route_table_id         = aws_route_table.insights_route_table_private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.insights_nat_gateway[count.index].id
}

resource "aws_route_table_association" "insights_route_table_association_public" {
  count          = length(var.vpc_public_subnets_cidr)
  subnet_id      = element(aws_subnet.insights_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.insights_route_table_public.id
}

resource "aws_route_table_association" "insights_route_table_association_private" {
  count          = length(var.vpc_private_subnets_cidr)
  subnet_id      = element(aws_subnet.insights_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.insights_route_table_private[count.index].id
}

resource "aws_security_group" "default" {
  name        = "vpc-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.insights_vpc.id
  depends_on  = [aws_vpc.insights_vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  
  tags = merge(
    local.common_tags,
  )
}