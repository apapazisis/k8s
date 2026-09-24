resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "k8s-vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id  = aws_vpc.main.id
  egress  = []
  ingress = []
}

###########################
#### PUBLIC NETWORKING ####
###########################

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 0)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name                     = "k8s-public-a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name                     = "k8s-public-b"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 2)
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name                     = "k8s-public-c"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "k8s-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "k8s-public-route-table"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_b.id
}

resource "aws_route_table_association" "public_c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_c.id
}

###########################
### PRIVATE NETWORKING ####
###########################

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, 3)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name                              = "k8s-private-a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, 4)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name                              = "k8s-private-b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, 5)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name                              = "k8s-private-c"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Elastic IP is associated with NAT GATEWAY and is
# used as source IP to access the internet from the private networks
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
resource "aws_eip" "eip_public_a" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "eks-eip-public-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_public_a" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.eip_public_a.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "eks-nat-gateway-public-a"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-private-a-route-table"
  }
}

resource "aws_route" "route_public_a" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_public_a.id
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_b" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.private_b.id
}

resource "aws_route_table_association" "private_c" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.private_c.id
}
