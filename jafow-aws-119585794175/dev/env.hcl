locals {
  stage = "dev"
  common_tags = {terraform_managed = "true", environment = "dev", stage = "dev", namespace = "jf"}
  namespace = "jf"
  hosted_zone_id = "Z070903534F7DYMQWH658"
}
