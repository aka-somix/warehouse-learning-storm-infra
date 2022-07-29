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
    aws_api_gateway_warehouse = {}
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

  # API Gateway Rest API endpoint
  aws_api_gateway_warehouse = dependency.core.outputs.aws_api_gateway_warehouse

  # Dynamodb access table
  aws_iam_policy_products_table_read_write_access = dependency.data.outputs.aws_iam_policy_products_table_read_write_access
}