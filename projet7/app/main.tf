terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
  required_version = "1.10.5"
}
provider "aws" {
  alias                    = "east"
  region                   = local.region
  shared_credentials_files = ["../../.secrets/creds"]
  profile                  = "default"

}
module "natgw" {
    source = "../modules/natgw_modules"
    id_vpc = module.vpc.vpc_sortie_id
    id_subnet_pub = module.list_subnet.public_1_sortie_id
}
module "sg" {
  source = "../modules/sg_modules"
  id_vpc = module.vpc.vpc_sortie_id
}
module "list_subnet" {
  source = "../modules/subnet_modules"
  net_vpc = local.net_vpc
  id_vpc = module.vpc.vpc_sortie_id
  region = local.region
}
module "ec2_public" {
  source = "../modules/ec2_modules"
  type_instance = local.type_instance
  projet_tags = local.projet_tags
  secur_group = [ module.sg.sortie_sg_id ]
  id_subnet = module.list_subnet.public_2_sortie_id
  expo = true
}

module "vpc" {
    source = "../modules/vpc_modules"
    net_vpc = local.net_vpc
    projet_tags = local.projet_tags
}
resource "aws_route_table_association" "route_public_1" {
    subnet_id =module.list_subnet.public_1_sortie_id
    route_table_id = module.vpc.route_public_table_id
  
}
resource "aws_route_table_association" "route_public_2" {
    subnet_id =module.list_subnet.public_2_sortie_id
    route_table_id = module.vpc.route_public_table_id
  
}
resource "aws_route_table_association" "route_private_1" {
    subnet_id = module.list_subnet.private_1_sortie_id
    route_table_id = module.natgw.route_private_table_id
  
}
resource "aws_route_table_association" "route_private_2" {
    subnet_id = module.list_subnet.private_2_sortie_id
    route_table_id = module.natgw.route_private_table_id
  
}

resource "null_resource" "sortie" {
    provisioner "remote-exec" {

    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx"
    ]

  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("../../.secrets/Giltab-us.pem")
    host        = module.ec2_public.sortie_ec2_pub

  }
  
}