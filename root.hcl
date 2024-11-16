locals {
  project_name = "leonomano-website"
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name   = local.account_vars.locals.account_name
  account_id     = local.account_vars.locals.aws_account_id
  aws_region     = local.region_vars.locals.aws_region
  environment    = local.environment_vars.locals.environment
  role_arn       = lookup(local.environment_vars.locals, "role_arn", null)
  backend_config = local.account_vars.locals.backend

  backend_s3Bucket      = "${local.backend_config.bucket}-${local.account_id}-${local.aws_region}"
  backend_s3DynamoTable = "${local.backend_config.dynamodb_table}-${local.account_id}-${local.aws_region}"
  default_tags = {
    Project = local.project_name
    Account = local.account_name
    Env     = local.environment
    Region  = local.aws_region
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region              = local.aws_region
    bucket              = local.backend_s3Bucket
    dynamodb_table      = local.backend_s3DynamoTable
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    profile             = lookup(local.backend_config, "profile", null)
    role_arn            = local.role_arn
    encrypt             = lookup(local.backend_config, "encrypt", false)
    allowed_account_ids = lookup(local.backend_config, "restrict_account", false) ? [local.account_id] : []
  }
}

# Generate an AWS provider block
generate "aws_provider" {
  path      = "aws.provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
  provider "aws" {
    region  = "${local.aws_region}"
    assume_role {
      role_arn = "${local.role_arn}"
      session_name = "terragrunt-service-role"
    }

    # Only these AWS Account IDs may be operated on by this template
    allowed_account_ids = ["${local.account_id}"]
  }
EOF
}

inputs = {
  project_name = local.project_name
  aws_region   = local.aws_region
  env          = local.environment
  default_tags = local.default_tags
}
