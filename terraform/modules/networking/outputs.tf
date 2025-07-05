output "rex_vpc_id" {
  value = aws_vpc.rex_vpc.id
}

output "rex_subnet_id" {
  value = aws_subnet.rex_subnet.id
}

output "rex_route_table_id" {
  value = aws_route_table.rex_route_table.id
}

output "rex_igw_id" {
  value = aws_internet_gateway.rex_igw.id
}