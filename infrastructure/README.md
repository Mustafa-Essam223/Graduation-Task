#### EKS Module
create an eks cluster on private subnets, and making its entrypoint private
eks-nodegroup with number of workernodes (min = 1,max = 1,desired=1) and access it using private-key
#### IAM Role 
two main roles are created for the whole cluster one for accessing services in the cluster(service-role-cluster) , and the other for worker nodes (eks_node_group_role)
#### EC2
one public machine act as a JumbHost to access the cluster
#### network
contain main vpc for the whole project eks-vpc and 4 subnets 2 public subnets, and 2 are private
