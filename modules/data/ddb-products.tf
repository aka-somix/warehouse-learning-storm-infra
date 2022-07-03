#
# DynamoDB Table to store warehouse products
#
resource "aws_dynamodb_table" "warehouse_products" {
  name         = "${var.project_name}-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Category"
  range_key    = "Identifier"

  attribute {
    name = "Category"
    type = "S"
  }

  attribute {
    name = "Identifier"
    type = "S"
  }

}

#
# Data Access Policies
#

# Gives Permission to read and write on the Warehouse Products table
resource "aws_iam_policy" "warehouse_products_read_access" {
  name   = "${var.project_name}-products-read-write-access"
  path   = "/${replace(var.project_name, "-", "/")}/dynamodb/products/readwriteaccess/"
  policy = data.aws_iam_policy_document.warehouse_products_read_access_document.json
}

data "aws_iam_policy_document" "warehouse_products_read_access_document" {
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
      aws_dynamodb_table.warehouse_products.arn
    ]
  }
}
