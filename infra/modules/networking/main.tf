resource "aws_vpc" "rex_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true

  tags = {
    Name = var.vpc_tags
  }
}

resource "random_shuffle" "az" {
  input        = ["${var.region}a", "${var.region}b", "${var.region}c", "${var.region}d", "${var.region}f"]
  result_count = 1
}

resource "aws_subnet" "rex_public_subnet" {
  vpc_id            = aws_vpc.rex_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = random_shuffle.az.result[0]

  tags = {
    Name = var.vpc_tags
  }
}

resource "aws_internet_gateway" "rex_igw" {
  vpc_id = aws_vpc.rex_vpc.id

  tags = { 
    Name = var.internet_gateway_tags
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.rex_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rex_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.rex_igw.id
  }

  tags = {
    Name = var.public_rt_tags
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.rex_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
