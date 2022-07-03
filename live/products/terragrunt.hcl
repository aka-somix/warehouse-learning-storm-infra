include {
  path   = find_in_parent_folders()
}

locals{
  globals = yamldecode(file(find_in_parent_folders("globals.yml")))
}

dependency "core" {
  config_path = find_in_parent_folders("core")
  mock_outputs = {
    aws_s3_bucket_lambda_packages = {}
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs_merge_with_state = contains(["init", "validate"], get_terraform_command()) ? true : false
}

dependency "data" {
  config_path = find_in_parent_folders("data")
  mock_outputs = {
    aws_iam_policy_products_table_read_write_access = {}
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs_merge_with_state = contains(["init", "validate"], get_terraform_command()) ? true : false
}

inputs = {
  # project configuration variables
  account_id              = get_aws_account_id()
  project_name            = local.globals.project_name
  region                  = local.globals.region

  # Bucket for Lambda Packages
  aws_s3_bucket_lambda_packages = dependency.core.outputs.aws_s3_bucket_lambda_packages

  # Dynamodb access table
  aws_iam_policy_products_table_read_write_access = dependency.data.outputs.aws_iam_policy_products_table_read_write_access
}
