terraform {
  source = "tfr:///terraform-aws-modules/ssm-parameter/aws//wrappers?version=1.1.2"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  defaults = {
    create               = true
    tier                 = "Standard"
    value                = "change_me"
    ignore_value_changes = true
    data_type            = "text"
    tags = {
      Terraform   = "true"
      TfModule    = "${get_path_from_repo_root()}"
      Environment = "dev"
    }
  }

  items = {
    cloudflare_api_token = {
      name        = "/account-configuration/us-east-1/dev/cloudflare_api_token"
      description = "Cloudflare API Token"
      type        = "SecureString"
      secure_type = true
    }
  }
}
