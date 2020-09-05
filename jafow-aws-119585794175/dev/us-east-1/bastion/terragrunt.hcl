locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl")) 
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl")) 

  # Extract out common variables for reuse
  stage = local.environment_vars.locals.stage
  tags = local.environment_vars.locals.common_tags
  region = local.region_vars.locals.aws_region
  account_id = local.account_vars.locals.aws_account_id
  hosted_zone_id = local.environment_vars.locals.hosted_zone_id
}

terraform {
  # source = "../../../../../terraform-modules/aws-blueprints/bastion"
  source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/bastion?ref=acm-0.1.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  tags = "${local.tags}"
  stage = "${local.stage}"
  region = "${local.region}"
  account_id = local.account_id
  vpc_id = "vpc-04c69cf0db7eb7880"
  subnet_ids = ["subnet-001271e0cc31dd2e6","subnet-0be2cf1a0f353716e","subnet-0840da807be430fb3"]
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDejvRzqnNrUjFTTXSbIY8L8oVn+WGlEZowPnamtNVrvsGpTkld84/piN6O3kRV1ZGuImY0vML8PHLxbwHPUwfTHnz0K1sYxwQtC985roXzXlSVDpCctfYrmgMEA3rUF/DU0Rsw/lcWZav51Bn+kr4BsxXVRFnYCy7W6hPpc6PYRhi05n0Ba8ve5OyKDRifwaNkJenPYT3k69EVQkPdVFQEFt1rxOsVB+ZXK3bEUhiUH+9in8OnZ3oWhmQZs4wwwN7HoiPSLKSvFPZB/YxsnBTB6xLd6uBNeGG+qeYkuwaxU94/CWtnaRt3UioFxqUIcAtwkPIht/dgXu4o69zVDMCU2pyZIGZQ9TW+bo2zvoM26rNjQHvY7JH1e9nc5o4EsbE6e7SfIM9P/IlQWHc49u4ziHo259p+6mDHslDDMC7P0ZG4gdMUItP/Chc+i98ZOFsSoTccVzCMX5Od8w2Pp+5xvN8EVa0FlzVpJQj+6gnJlIb64XtJfykDUrGA3uuXDSDy3cquVx79c7nYf+QIJEBUxPwSlk3bPTyTsT86u+v3b6tmeVJzdsRC/M1NEUaBPtVP8dNFlYbnl5cg7zivRllMn/VjkHCrQumnqfxr1Xsg9aRqosN5hx1D2Bkbyb9VfN7LypFwV+EjyZ2f86F+bBLiLaoBTW08ZTmngrW7O+uPrQ== foodoasis.net"
  ssh_public_key_names = ["jared"]
  enable_bastion_hostname = true
  hosted_zone_id = local.hosted_zone_id
  bastion_hostname = "bastion"
}
