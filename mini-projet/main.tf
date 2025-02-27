provider "aws" {
  alias                    = "east"
  region                   = var.region
  shared_credentials_files = ["../.secrets/creds"]
  profile                  = "default"

}

module "ec2" {
  source = "./modules/ec2_modules"
  type_instance = local.type_instance
  projet_tags = local.projet_tags
  security_groups = [ module.sg.sortie_sg ]
  availability_zone = local.availability_zone
}

module "ebs" {
  source = "./modules/ebs_modules"
  ebs_size = local.ebs_size
  availability_zone = local.availability_zone
}

module "eip" {
  source = "./modules/eip_modules"
}

module "sg" {
  source = "./modules/sg_modules"
}

resource "aws_eip_association" "public" {
  instance_id = module.ec2.sortie_ec2
  allocation_id = module.eip.sortie_publique
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.ebs_sortie
  instance_id = module.ec2.sortie_ec2
}

resource "null_resource" "sortie_totale" {
  depends_on = [ module.eip ]
  provisioner "local-exec" {
    command = "echo PUBDNS: ${module.eip.sortie_eippub} > out/ec2pub.txt"
  }
}