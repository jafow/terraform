locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  tags = local.environment_vars.locals.common_tags
}

terraform {
  source = "../../../../../terraform-modules/aws-blueprints/acm"
  # source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/acm?ref=acm-0.2.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  tags = "${local.tags}"
  enabled = true

  domain_name = "jred.online"
  route53_zone_name = "jred.online"
  subject_alternative_names = ["*.jred.online"]
}
