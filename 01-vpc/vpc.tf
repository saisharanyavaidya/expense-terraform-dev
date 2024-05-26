## ---------------- Below code calls terraform-aws-vpc module created from git and paasses all the variables listed.. this way it creates all VPC services that are listed in terraform-aws-vpc module
module "vpc" {
  source = "git::https://github.com/saisharanyavaidya/terraform-aws-vpc.git?ref=main"
  project_name = var.project_name
  common_tags = var.common_tags
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required = var.is_peering_required
}