provider "aws" {
  alias                    = "east"
  region                   = "us-east-1"
  shared_credentials_files = ["../.secrets/creds"]
  profile                  = "default"

}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "this" {
  ami             = data.aws_ami.this.id
  instance_type   = var.type_instance
  key_name        = var.us-Key
  tags            = var.tags
  security_groups = [aws_security_group.allow_http_https_ssh.name]

  provisioner "remote-exec" {

    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx"
    ]

  }
  connection {
    type        = "ssh"
    user        = var.ec2_user
    private_key = file("../.secrets/Giltab-us.pem")
    host        = self.public_ip

  }
  provisioner "local-exec" {
    command = "echo PRIVATE_IP : ${self.private_ip} ; AZ : ${self.availability_zone} ; PUBLIC_IP : ${self.public_ip} >> ../out/info-ec2.txt"

  }


}
resource "aws_eip" "lb" {
  instance = aws_instance.this.id
  domain   = "vpc"
  provisioner "local-exec" {
    command = "echo EIP : ${aws_eip.lb.public_ip} >> ../out/info-ec2.txt"

  }
}

resource "aws_security_group" "allow_http_https_ssh" {
  name = "terraform-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



output "public_ip" {
  value = aws_eip.lb.public_dns
}
