resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = { Name = var.vpc_name }
}

resource "aws_subnet" "public" {
  for_each = {
    for index, az in slice(data.aws_availability_zones.available.names, 0, var.az_count):
    az => index
  }
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value) #[0,2] -> 0, 1 左包右不包
  map_public_ip_on_launch = true

  tags = { Name = "${var.vpc_name}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = {
    for index, az in slice(data.aws_availability_zones.available.names, 0, var.az_count):
    az => index
  }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + var.az_count)
  tags = { Name = "${var.vpc_name}-private-${each.key}" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags ={ Name = "${var.vpc_name}-public-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.vpc_name}-public-routetable" }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = var.enable_nat ? 1:0
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat? 1:0

  allocation_id = aws_eip.nat[0].id
  subnet_id = values(aws_subnet.public)[0].id

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count = var.enable_nat? 1:0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.enable_nat? aws_subnet.private:{}

  subnet_id = each.value.id
  route_table_id = aws_route_table.private[0].id
  
}

data "aws_availability_zones" "available" {}