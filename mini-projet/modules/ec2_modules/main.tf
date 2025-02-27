data "aws_ami" "this" {
  most_recent = true
  owners      = ["099720109477"]

   filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  }

resource "aws_instance" "this" {
  ami             = data.aws_ami.this.id
  instance_type   = var.type_instance
  key_name        = var.us-Key
  tags            = var.projet_tags
  security_groups = var.security_groups
  availability_zone = var.availability_zone

  provisioner "remote-exec" {

    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx"
    ]

  }
  connection {
    type        = "ssh"
    user        = var.ec2_user
    private_key = file("../.secrets/Giltab-us.pem")
    host        = self.public_ip

  }
  provisioner "local-exec" {
    command = "echo 'PRIVATE_IP : ${self.private_ip} ; AZ : ${self.availability_zone} ; PUBLIC_IP : ${self.public_ip}' >> out/info-ec2.txt"

  }


}