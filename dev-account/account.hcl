locals {
  account_name   = "leonomano"
  aws_account_id = "378041425110"
  backend = {
    bucket           = "leonomano-website-tf-state"
    dynamodb_table   = "leonomano-website-tf-state"
    encrypt          = true
    restrict_account = true
  }
}
