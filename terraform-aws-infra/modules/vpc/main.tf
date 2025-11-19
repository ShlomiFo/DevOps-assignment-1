
resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags       = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidr
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.name}-public" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_cidr
  availability_zone = var.azs[0]
  tags = merge(var.tags, { Name = "${var.name}-private" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
