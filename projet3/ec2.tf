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
  key_name        = "Giltab-us"
  tags            = var.tags
  security_groups = [aws_security_group.allow_http_https_ssh.name]
}
resource "aws_eip" "lb" {
  instance = aws_instance.this.id
  domain   = "vpc"
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