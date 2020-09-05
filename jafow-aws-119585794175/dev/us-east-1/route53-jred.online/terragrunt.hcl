locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 

  # tags = {terraform_managed = "true", stage = local.stage, namespace = local.environment_vars.locals.namespace}

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  tags = local.environment_vars.locals.common_tags
}

terraform {
  # source = "../../../../../terraform-modules/aws-blueprints/route53"
  source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/route53?ref=route53-0.1.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  tags = { terraform_managed = "true", stage = "a", namespace = "jred" }

  main_zone_name = "jred.online"
  sub_dns_name = "c"
}
