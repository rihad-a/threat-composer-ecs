resource "aws_vpc" "terraform_vpc" {
    cidr_block = var.vpc-cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    tags = {
      Name = "terraform_vpc"
    }
  
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "public_1" {
  cidr_block              = var.subnet-cidrblock-pub1
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_public
  availability_zone       = var.subnet-az-2a

  tags = {
    Name = "public1"
  }
}
resource "aws_subnet" "private_1" {
  cidr_block              = var.subnet-cidrblock-pri1
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_private
  availability_zone       = var.subnet-az-2a

  tags = {
    Name = "private1"
 }
}

resource "aws_subnet" "public_2" {
  cidr_block              = var.subnet-cidrblock-pub2
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_public
  availability_zone       = var.subnet-az-2b

  tags = {
    Name = "public2"
  }
}
resource "aws_subnet" "private_2" {
  cidr_block              = var.subnet-cidrblock-pri2
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_private
  availability_zone       = var.subnet-az-2b

  tags = {
    Name = "private2"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "nat_gw"
}

depends_on = [aws_internet_gateway.gw]

}

resource "aws_eip" "ngw_eip" {

}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.routetable-cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.routetable-cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_route"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_route.id
}
