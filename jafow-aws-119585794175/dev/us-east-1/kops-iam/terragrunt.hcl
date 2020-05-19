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
  source = "../../../../../terraform-modules/aws-blueprints/kops-iam"
  # source = "git@github.com:jafow/terraform-modules.git//aws-blueprints/kops-iam?ref=kops-iam-0.1.1"
}

include {
  path = find_in_parent_folders()
}


inputs = {
  tags = "${local.tags}"
  stage = local.stage
  region = local.region_vars.locals.aws_region

  aws_account_id = "${local.account_vars.locals.aws_account_id}"
  group_name  = "kops"
  user_name = "kops"
  path_name = "/kops/"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcXp3Qb+baSkNZORxVCqeM9tHTcNgxp+yk7W6G37uvU4Yw7uMn/HNyQfH5c41ksmLQlwHGA188baHwhwCMCCjgXrvG0DnGsXagX1WbR/6Ga/E6CgkPLh1TiNIwq8IV38A3dllKq9q6cJvVQa6o0mwsQR3mOCH8y34WU3x6LFTpsX2qBekwyTyTAlKnuvnddV8wp1izHE2Iz7Y+228W0d3gWd22qcurcjDMk8RL0KGUlzcum7NfMkenFuyotYjB17Me7Qs/pCVahETrZK68SzQCdJ1yQn5U0qk5vRKjALeWhqoM2PWXUwY9bHaLqWL+b6CUrKEzZo8gQYq+ro8G+h2uTR35aNS2uNqVtWyplJin+CYYEtrtalzVwFezE9xPpU9RgKbozjUMdXT8zgy9/Q6ZFRxp5UwbP+u+lQtIegRNb8Eo8paPpg/aLCkjEWSLocX7Ipkw9jOUWHX/DnI9dN2hs/s9MvNzqcM+2hctumTXOEUxEsYO2s+/08vx/P1pmsvEkVE+Ljq4CcI8flBD1Ao2YFlKrLsyXOwqJ0fs6yZGivhB9rMeRaWzPMEX55KNxauKHbCvBFOUn3HTQf7hDv+7+3HwWYAMXc8YvprXGNN9hsd0hyMs4d9DLR3tzzol76v3NnkYBGQu4v4Moe8kcp6MdFDApk1wL4ssVRzx4XefcQ== jaredfowler@beepbox"
}
