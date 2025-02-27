terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
  required_version = "1.10.5"
}

variable "type_instance" {
  type    = string
  default = "t2.nano"

}

variable "tags" {
  type        = map(any)
  description = "value tag"
  default = {
    Name = "ec2-tag"
  }

}
variable "ec2_user" {
  type    = string
  default = "ec2-user"

}

variable "us-Key" {
  type    = string
  default = "Giltab-us"

}