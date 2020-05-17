locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
}

terraform {
  # source = "../../../../../terraform-modules/aws-blueprints/ec2"
  source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/ec2?ref=ec2-0.1.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  name = "helloec2"
  stage = "${local.stage}"
  tags = {"terraform_managed" = "true" }
}
