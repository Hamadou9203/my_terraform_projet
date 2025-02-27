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
variable "ec2_user" {
  type    = string
  default = "ubuntu"

}

variable "us-Key" {
  type    = string
  default = "Giltab-us"

}

variable "region" {
  type    = string
  default = "us-east-1"

}
variable "projet_tags" {
  type        = map(any)
  description = "value tag"
  default = {
    Name = "my-projet"
  }

}
variable "security_groups" {
  type = set(string)
  default = null
}

variable "availability_zone" {
  type = string
   default = "us-east-1a"
}