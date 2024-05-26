##-----------Below code refers to fetching data from aws ssm parameter store that we stored in 01-vpc parameters.tf

data "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
}