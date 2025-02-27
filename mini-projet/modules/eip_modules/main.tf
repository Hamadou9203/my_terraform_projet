resource "aws_eip" "lb" {
  
  domain   = "vpc"
  provisioner "local-exec" {
    command = "echo EIP : ${aws_eip.lb.public_ip} >> out/info-ec2.txt"

  }
}