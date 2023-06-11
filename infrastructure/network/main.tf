# vpc 
# subnets 
# security group
# igw
# nat

resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-vpc"
  }
}
 resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id 
  tags = {
    Name = "IGW"
  }
} 
resource "aws_security_group" "eks_control_plane_sg" {
  name        = "eks-sg" 
  description = "Security group for EKS control plane"
  vpc_id = aws_vpc.main-vpc.id  # Update with your VPC ID

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust as per your security requirements
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust as per your security requirements
  }
}

resource "aws_subnet" "main-vpc-subnets" {
  count = 4 
  vpc_id = aws_vpc.main-vpc.id 
  cidr_block = var.cidr_blocks[count.index]
  availability_zone =  var.zones[count.index]
  map_public_ip_on_launch = count.index < 2? true:false
  tags = {
  Name = var.subnet-names[count.index]
  }

} 
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "NAT"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.main-vpc-subnets[0].id
  tags = {
    Name = "NAT"
  }
  depends_on = [ aws_internet_gateway.igw ]
}


resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.main-vpc.id 
 
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-route-NAT"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.main-vpc.id 
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-igw"
  }
}

resource "aws_route_table_association" "public-route-assiciate" {
  count = 2
  subnet_id = aws_subnet.main-vpc-subnets[count.index].id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "private-route-association" {
  count = 2
  subnet_id = aws_subnet.main-vpc-subnets[count.index+2].id
  route_table_id = aws_route_table.private-route.id
}
  


