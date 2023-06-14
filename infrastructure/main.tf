provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
}
module "network" {
  source = "./network"
}
module "iam_role" {
  source = "./IAM"
}
module "eks" {
  source                  = "./EKS"
  depends_on              = [module.iam_role, module.network] # for eks & nodegroup
  eks-service-role____arn = module.iam_role.service-role-cluster__arn
  eks-node-role____arn    = module.iam_role.eks-node-role____arn
  subnet_list____ids      = [module.network.private-subnet3, module.network.private-subnet4]
  #module.network.subnet1-id, module.network.subnet2 : edited to prevent the nodes from being with puclic ip , connected with internet through nat
  ssh_key           = "GradKey"
  security-group-id = module.network.sg-id
  vpc-id            = module.network.vpc-id

}
module "Jumb-Host" {
  source        = "./ec2"
  ami           = "ami-053b0d53c279acc90"
  instance-type = "t2.micro"
  #inst-profile = module.iam_role.eks-node-role____name
  subnet-id     = module.network.public-subnet1
  sg-id         = module.network.sg-id
  instance_name = "Jumb-Host"

}
