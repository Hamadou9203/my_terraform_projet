resource "aws_ebs_volume" "my-ebs" {
  availability_zone = var.availability_zone
  size              = var.ebs_size

  tags = var.projet_tags
}