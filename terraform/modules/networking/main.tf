
resource "aws_vpc" "production_vpc" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "production-eks-vpc"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name = "production-eks-igw"
  }
}

resource "aws_subnet" "public_subnet_1" {

  vpc_id = aws_vpc.production_vpc.id

  cidr_block = var.public_subnet_1

  availability_zone = var.az1

  map_public_ip_on_launch = true

  tags = {
    Name = "production-public-subnet-1"

    "kubernetes.io/role/elb" = "1"

  }
}

resource "aws_subnet" "public_subnet_2" {

  vpc_id = aws_vpc.production_vpc.id

  cidr_block = var.public_subnet_2

  availability_zone = var.az2

  map_public_ip_on_launch = true

  tags = {
    Name = "production-public-subnet-2"

    "kubernetes.io/role/elb" = "1"

  }
}

resource "aws_subnet" "private_subnet_1" {

  vpc_id = aws_vpc.production_vpc.id

  cidr_block = var.private_subnet_1

  availability_zone = var.az1

  map_public_ip_on_launch = false

  tags = {
    Name = "production-private-subnet-1"

    "kubernetes.io/role/internal-elb" = "1"

  }
}

resource "aws_subnet" "private_subnet_2" {

  vpc_id = aws_vpc.production_vpc.id

  cidr_block = var.private_subnet_2

  availability_zone = var.az2

  map_public_ip_on_launch = false

  tags = {
    Name = "production-private-subnet-2"

    "kubernetes.io/role/internal-elb" = "1"

  }
}

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "production-eks-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "production-eks-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "production-eks-public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "production-eks-private-rt"
  }
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}


resource "aws_security_group" "eks_cluster_sg" {

  name        = "production-eks-cluster-sg"
  description = "Security group for the Production EKS cluster"
  vpc_id      = aws_vpc.production_vpc.id

  tags = {
    Name = "production-eks-cluster-sg"
  }
}
