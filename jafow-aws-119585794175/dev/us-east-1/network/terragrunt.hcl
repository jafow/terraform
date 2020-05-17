locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 
  # tags = {terraform_managed = "true", stage = local.stage, namespace = local.environment_vars.locals.namespace}

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  tags = merge({Name = "network"}, local.environment_vars.locals.common_tags)
}

terraform {
  source = "../../../../../terraform-modules/aws-blueprints/network"
  # source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/network?ref=network-0.1.0-alpha"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  namespace = local.environment_vars.locals.namespace
  stage = "${local.stage}"
  region = "${local.region_vars.locals.aws_region}"
  tags = "${local.tags}"

  name = "network"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cidr_block = "10.100.0.0/16"
}

