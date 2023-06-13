resource "aws_eks_cluster" "eks-cluster" {
  name = "eks-cluster"
  role_arn = var.eks-service-role____arn
  vpc_config {
    subnet_ids = var.subnet_list____ids
    endpoint_private_access = true
    security_group_ids = [var.security-group-id]
  } 
} 
resource "aws_eks_node_group" "private" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_group_name = "worker-nodes"
  node_role_arn = var.eks-node-role____arn
  
  subnet_ids = var.subnet_list____ids
  instance_types = ["t2.medium"]
  #ami = "ami-053b0d53c279acc90"

  scaling_config {
    desired_size = 1
    min_size = 1
    max_size = 1
  }
  remote_access {
    ec2_ssh_key = var.ssh_key
  }
  #depends on roles of node-group
}







