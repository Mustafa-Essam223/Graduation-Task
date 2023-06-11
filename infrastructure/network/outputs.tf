output "subnet1-id" {
  value = aws_subnet.main-vpc-subnets[0].id 
}
output "subnet2-id" {
  value = aws_subnet.main-vpc-subnets[1].id 
}
output "subnet3-id" {
  value = aws_subnet.main-vpc-subnets[2].id 
}
output "subnet4-id" {
  value = aws_subnet.main-vpc-subnets[3].id 
}
output "vpc-id" {
    value=aws_vpc.main-vpc.id
}
output "sg-id" {
    value=aws_security_group.eks_control_plane_sg.id

}

