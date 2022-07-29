
output "aws_s3_bucket_lambda_packages" {
  value = aws_s3_bucket.lambda_packages
}


# Export the API Gateway resource so that can be extended by
# other modules
output "aws_api_gateway_warehouse" {
  value = aws_api_gateway_rest_api.warehouse
}
