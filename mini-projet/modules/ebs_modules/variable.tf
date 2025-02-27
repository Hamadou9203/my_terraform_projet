variable "availability_zone" {
  type = string
   default = "us-east-1a"
}

variable "ebs_size" {
  type = number
  default = 25
}

variable "projet_tags" {
  type        = map(any)
  description = "value tag"
  default = {
    Name = "my-projet"
  }

}