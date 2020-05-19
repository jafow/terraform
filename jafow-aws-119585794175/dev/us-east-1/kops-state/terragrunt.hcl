locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 
  account_vars =  read_terragrunt_config(find_in_parent_folders("account.hcl")) 
  tags = local.environment_vars.locals.common_tags


  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  account_id = local.account_vars.locals.aws_account_id
  region = local.region_vars.locals.aws_region
}

terraform {
    # source = "../../../../../terraform-modules/aws-blueprints/s3"
    source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/s3?ref=s3-0.2.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  stage = "${local.stage}"

  bucket_name = "jafow-${local.account_id}-${local.stage}-${local.region}-kops-state"
  account_id = local.account_vars.locals.aws_account_id
  sse_enabled = true
  tags = merge(local.tags, {"region" = local.region}, {"kops" = 1 })
  bucket_principal_arn = "arn:aws:iam::119585794175:user/kops/kops"
}
