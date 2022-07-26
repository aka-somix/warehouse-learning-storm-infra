resource "aws_lambda_function" "products_handler" {
  function_name = "${var.project_name}-products-handler"
  memory_size   = 128

  s3_bucket = var.aws_s3_bucket_lambda_packages.id
  s3_key    = aws_s3_object.lambda_zip_build.key

  handler = "src/index.handler"
  runtime = "nodejs16.x"

  role = aws_iam_role.products_handler.arn

  depends_on = [
    aws_iam_role_policy_attachment.dynamodb_products_access
  ]
}

#
# IAM Role for Lambda function
#
resource "aws_iam_role" "products_handler" {
  name = "${var.project_name}-products-handler"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Lambda Basics Policy (Cloudwatch logs)
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.products_handler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB Products Table Policy
resource "aws_iam_role_policy_attachment" "dynamodb_products_access" {
  role       = aws_iam_role.products_handler.name
  policy_arn = var.aws_iam_policy_products_table_read_write_access.arn
}

#
# -- Resource Policy --
# Grants access to APIGateway
#
resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.products_handler.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.aws_api_gateway_warehouse.execution_arn}/*/*/*"

  depends_on = [
    aws_api_gateway_resource.products_proxy
  ]
}


#
# Upload a Dummy Zip with a HelloWorld Lambda
#
resource "aws_s3_object" "lambda_zip_build" {
  bucket = var.aws_s3_bucket_lambda_packages.id
  key    = "products-handler/build.zip"
  source = "./dummy-lambda.zip"
  etag   = filemd5("./dummy-lambda.zip")
}
