locals {
  # Automatically load global variables
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_vars.locals.registry_url}/website"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  domain_name = "leonomano.com"
  aws_profile = "website"
}
