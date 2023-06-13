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
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 30357
    to_port     = 30357
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

resource "aws_subnet" "main-vpc-subnets" {
  count = 4 
  vpc_id = aws_vpc.main-vpc.id 
  cidr_block = var.cidr_blocks[count.index]
  #default  = ["public-us-east-1a","public-us-east-2a","private-us-east-1b","private-us-east-2b"]
  
  availability_zone =  count.index == 0 || count.index == 2 ? var.zones[0] : var.zones[1]  
  map_public_ip_on_launch = count.index < 2 ? true : false
  tags = {
  Name = var.subnet-names[count.index]
  "kubernetes.io/cluster/eks-cluster"       = "shared" 
  "kubernetes.io/role/internal-elb" = 1
  "kubernetes.io/role/elb" = 1

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
  
  subnet_id = aws_subnet.main-vpc-subnets[2].id
  route_table_id = aws_route_table.private-route.id
}
  
resource "aws_route_table_association" "private-route-association1" {
  subnet_id = aws_subnet.main-vpc-subnets[3].id
  route_table_id = aws_route_table.private-route.id
}
  

