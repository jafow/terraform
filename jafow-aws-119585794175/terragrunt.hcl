# stage/terragrunt.hcl

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}


remote_state {
  backend = "s3"
  generate = {
    path      = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "jafow-dev-${local.account_id}-${local.aws_region}-tf-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "tf-state"
  }
}

generate "provider" {
    path = "generated-provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::119585794175:role/AssumedRole"
  }
  region = "us-east-1"
}
EOF
}

terraform {
  extra_arguments "parallelize" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = ["-parallelism=1000"]
  }

  after_hook "cleanup" {
    commands     = ["apply", "plan"]
    execute      = ["sh", "-c", "cd ${get_terragrunt_dir()} && find . -type d -name .terragrunt-cache -prune -exec rm -rf {} \\;"]
    run_on_error = true
  }

  extra_arguments "always_local_plan" {
    commands  = ["plan"]
    arguments = ["-out=./saved-plan"]
  }
}
