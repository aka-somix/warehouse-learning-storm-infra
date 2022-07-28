#
# DynamoDB Table to store warehouse requests
#
resource "aws_dynamodb_table" "warehouse_requests" {
  name         = "${var.project_name}-requests"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UUID"
  range_key    = "Identifier"


  attribute {
    name = "UUID"
    type = "S"
  }

  attribute {
    name = "Identifier"
    type = "S"
  }

  ttl {
    attribute_name = "ExpirationTime"
    enabled        = true
  }

}

#
# Data Access Policies
#

# Gives Permission to read and write on the Warehouse Requests table
resource "aws_iam_policy" "warehouse_requests_read_access" {
  name   = "${var.project_name}-requests-read-write-access"
  path   = "/${replace(var.project_name, "-", "/")}/dynamodb/requests/readwriteaccess/"
  policy = data.aws_iam_policy_document.warehouse_requests_read_access_document.json
}

data "aws_iam_policy_document" "warehouse_requests_read_access_document" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      aws_dynamodb_table.warehouse_requests.arn
    ]
  }
}
