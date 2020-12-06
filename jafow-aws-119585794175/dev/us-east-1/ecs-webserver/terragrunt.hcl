locals {
  # Automatically load environment-level variables
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  stage  = local.environment_vars.locals.stage
  tags   = local.environment_vars.locals.common_tags
  region = local.region_vars.locals.aws_region
}

terraform {
  source = "git@github.com:100automations/terraform-loadbalanced-ecs-webapp.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  # common
  tags       = "${local.tags}"
  namespace  = "1ha"
  region     = "${local.region}"
  stage      = "dv1"

  acm_certificate_arn = "arn:aws:acm:us-east-1:119585794175:certificate/0e6d47ae-5cc1-4a63-9f75-58463464fbe5"
  vpc_id = "vpc-04c69cf0db7eb7880"

  task_definition_file = "task.json"

  public_subnet_ids = [
    "subnet-001271e0cc31dd2e6",
    "subnet-0840da807be430fb3",
    "subnet-0be2cf1a0f353716e",
  ]

  # app
  project_name     = "my-app"
  task_name        = "webserver"
  container_name   = "expressjs"
  container_port   = 80
  container_cpu    = 256
  container_memory = 1024
  desired_count    = 1


  extra_task_definition_vars = {
     foo = "bar"
     cool = true
  }
}
