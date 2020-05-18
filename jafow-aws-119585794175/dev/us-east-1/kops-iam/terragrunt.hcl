locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 
  account_vars =  read_terragrunt_config(find_in_parent_folders("account.hcl")) 

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  tags = local.environment_vars.locals.common_tags
}

terraform {
  # source = "../../../../../terraform-modules/aws-blueprints/kops-iam"
  source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/kops-iam?ref=kops-iam-0.1.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  tags = "${local.tags}"

  aws_account_id = "${local.account_vars.locals.aws_account_id}"
  group_name  = "kops"
  path_name = "/kops/"
}
