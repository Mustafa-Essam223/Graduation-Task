resource "aws_iam_instance_profile" "ec2_prof" {
  name = "prof"
  role = "eks-group-nodes"
}
resource "aws_instance" "public-instance" {

  ami           = var.ami # "ami-0989fb15ce71ba39e"
  instance_type = var.instance-type # "t2.medium"
  subnet_id                   = var.subnet-id #var.subnet-id[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sg-id] 
  key_name = var.my-key-name
    iam_instance_profile = aws_iam_instance_profile.ec2_prof.name
 
  /* provisioner "local-exec" {
    command = "echo ${self.id} >> ./public_vm_ids" 
  } */
  provisioner "remote-exec" {
    inline = [ "sudo apt-get update" ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("./${var.my-key-name}.pem")
    }
  }  
    
   tags = {
      Name = "${var.instance_name}" 
   }
  
}