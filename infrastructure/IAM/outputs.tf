output "service-role-cluster__arn" {
  value = aws_iam_role.service-role-cluster.arn
}
output "eks-node-role____arn" {
  value = aws_iam_role.eks_node_group_role.arn
}
output "eks-node-role____name" {
  value = aws_iam_role.eks_node_group_role.name
}