variable "cidr_blocks" {
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24" ]
}
variable "zones" {
    type = list(string)
    default  = ["us-east-1a","us-east-1b"]
}
variable "subnet-names" {
  type = list(string)
  default  = ["public-us-east-1a","public-us-east-2a","private-us-east-1b","private-us-east-2b"]
}
/* variable "subnet-key" {} */