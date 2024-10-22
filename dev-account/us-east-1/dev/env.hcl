locals {
  environment = "dev"
  role_arn    = "arn:aws:iam::378041425110:role/leonomano-website-tf-service-user"
  backend = {
    bucket           = "leonomano-website-tf-state"
    dynamodb_table   = "leonomano-website-tf-state"
    encrypt          = true
    restrict_account = true
  }
}
