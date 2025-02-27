provider "aws" {
  alias  = "east"
  region = "us-east-1"
  shared_credentials_files = ["../.secrets/creds"]
  profile = "default"
 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "vpc-0ed620dc8f59bf872"

  tags = {
    Name = "sortie"
  }
}

resource "aws_route" "route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = "rtb-0abd9b7e33c428b8e"
  gateway_id = aws_internet_gateway.gw.id
}


resource "aws_instance" "first" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  subnet_id = "subnet-09d7b916c3f258a95"
  vpc_security_group_ids = ["sg-009e787074e4f09f8"]
  

  tags = {
    Name = "first-instance"
  }
  user_data = <<EOF

   #!/bin/bash
   curl -fsSL https://get.docker.com -o install-docker.sh
   sh install-docker.sh --dry-run
   sudo sh install-docker.sh
   sudo usermod -aG docker ubuntu
   sudo sh -eux apt-get install -y uidmap
   dockerd-rootless-setuptool.sh install

    EOF
}
