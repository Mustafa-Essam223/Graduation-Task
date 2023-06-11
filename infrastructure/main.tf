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
  eks-node-role____arn = module.iam_role.eks-node-role____arn
  subnet_list____ids      = [module.network.subnet1-id, module.network.subnet2-id, module.network.subnet3-id, module.network.subnet4-id]
  security-group-id = module.network.sg-id
  vpc-id = module.network.vpc-id

}