output "vpc_id" {
  value = aws_vpc.rex_vpc.id
  
}

output "subnet_id" {
  value = aws_subnet.rex_public_subnet.id
  
}

output "igw_id" {
  value = aws_internet_gateway.rex_igw
  
}