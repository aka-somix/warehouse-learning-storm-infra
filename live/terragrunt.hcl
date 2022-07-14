/* 
 *    ---- TERRAGRUNT ----
 *    Root Configurations      
 */

locals {
  globals = yamldecode(file("globals.yml"))

  default_tags = local.globals.tags
}

remote_state {
  backend = "s3"
  config = {
    encrypt             = true
    bucket              = "${local.globals.project_name}-terraform-state-${get_aws_account_id()}-${local.globals.region}"  
    key                 = "${path_relative_to_include()}/terraform.tfstate" 
    region              = local.globals.region
    dynamodb_table      = "${local.globals.project_name}-terraform-state"
    s3_bucket_tags      = local.default_tags
    dynamodb_table_tags = local.default_tags
  }
}

terraform {
  source = "${path_relative_from_include()}/../modules/${path_relative_to_include()}"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "${local.globals.region}"
  }
  EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
