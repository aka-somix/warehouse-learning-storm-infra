#
# -- REQUESTS RESOURCE --
# Needed to call /requests/ endpoint 

resource "aws_api_gateway_resource" "requests" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  parent_id   = var.aws_api_gateway_warehouse.root_resource_id
  path_part   = "requests"
}


resource "aws_api_gateway_method" "any_requests" {
  rest_api_id      = var.aws_api_gateway_warehouse.id
  resource_id      = aws_api_gateway_resource.requests.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "requests" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  resource_id = aws_api_gateway_method.any_requests.resource_id
  http_method = aws_api_gateway_method.any_requests.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.requests_handler.invoke_arn

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

#
# -- PROXY RESOURCE --
# Proxies everything after /requests/* to the lambda function

resource "aws_api_gateway_resource" "requests_proxy" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  parent_id   = aws_api_gateway_resource.requests.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "any_requests_proxy" {
  rest_api_id      = var.aws_api_gateway_warehouse.id
  resource_id      = aws_api_gateway_resource.requests_proxy.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "requests_proxy" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  resource_id = aws_api_gateway_method.any_requests_proxy.resource_id
  http_method = aws_api_gateway_method.any_requests_proxy.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.requests_handler.invoke_arn

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

# 
# -- OPTIONS METHOD (Required for CORS)
#
resource "aws_api_gateway_method" "options" {
  rest_api_id      = var.aws_api_gateway_warehouse.id
  resource_id      = aws_api_gateway_resource.requests_proxy.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  resource_id = aws_api_gateway_resource.requests_proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  resource_id = aws_api_gateway_resource.requests_proxy.id
  http_method = aws_api_gateway_method.options.http_method

  type             = "MOCK"
  content_handling = "CONVERT_TO_TEXT"

  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = var.aws_api_gateway_warehouse.id
  resource_id = aws_api_gateway_resource.requests_proxy.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,DELETE,GET,HEAD,PATCH,POST,PUT'"
  }

  depends_on = [
    aws_api_gateway_method_response.options_200,
    aws_api_gateway_integration.options,
  ]
}
