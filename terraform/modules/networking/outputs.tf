
output "vpc_id" {
  description = "Prodution EKS Platform  VPC ID"
  value       = aws_vpc.production_vpc.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {

  description = "Public Subnet IDs"

  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {

  description = "Private Subnet IDs"

  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "nat_eip_id" {

  description = "Elastic IP allocation ID for NAT Gateway"

  value = aws_eip.nat_eip.id

}

output "nat_gateway_id" {

  description = "NAT Gateway ID"

  value = aws_nat_gateway.nat_gateway.id

}

output "public_route_table_id" {

  description = "Public Route Table ID"

  value = aws_route_table.public_route_table.id

}

output "private_route_table_id" {

  description = "Private Route Table ID"

  value = aws_route_table.private_route_table.id

}

output "eks_cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"

  value = aws_security_group.eks_cluster_sg.id
}