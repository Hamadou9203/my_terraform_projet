provider "aws" {
  alias                    = "east"
  region                   = "us-east-1"
  shared_credentials_files = ["../.secrets/creds"]
  profile                  = "default"

}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-backend-hamadou-1992"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
