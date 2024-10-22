locals {
  # Automatically load global variables
  account_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.account_vars.registry_url}/website"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
