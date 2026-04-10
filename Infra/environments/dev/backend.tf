terraform {
  backend "s3" {
    bucket         = "tf-lock-s3-20260218"
    key            = "week2/day2/terraform-vpc-each-subnet.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}