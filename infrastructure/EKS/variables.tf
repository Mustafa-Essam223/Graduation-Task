variable "eks-service-role____arn" {
  type = string
}
variable "eks-node-role____arn" {
  type = string
}
variable "security-group-id" {
  type = string
}
variable "vpc-id" {
  type = string
}
  

variable "subnet_list____ids" {
  type = list(string)
}