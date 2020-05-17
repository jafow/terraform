locals {
  stage = "dev"
  common_tags = {terraform_managed = "true", environment = "dev", stage = "dev", namespace = "jf"}
  namespace = "jf"
}
