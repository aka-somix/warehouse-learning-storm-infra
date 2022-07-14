variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "aws_s3_bucket_lambda_packages" {
  type = object({
    id  = string,
    arn = string
  })
}

variable "aws_api_gateway_warehouse" {
  type = object({
    id               = string,
    arn              = string,
    root_resource_id = string,
    execution_arn    = string
  })
}

variable "aws_iam_policy_products_table_read_write_access" {
  type = object({
    arn = string
  })
}
