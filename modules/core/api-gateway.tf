
resource "aws_api_gateway_rest_api" "warehouse" {
  name = "${var.project_name}-API-REST"

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "${var.project_name}"
      version = "1.0"
    }
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#
# ---- API Deployment ----
# Redeploys the API when the body changes (== tied to version)
#
resource "aws_api_gateway_deployment" "learning" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.warehouse.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.get_health,
  ]
}

resource "aws_api_gateway_stage" "learning" {
  deployment_id = aws_api_gateway_deployment.learning.id
  rest_api_id   = aws_api_gateway_rest_api.warehouse.id
  stage_name    = "learning"
}

resource "aws_api_gateway_method_settings" "path_specific" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id
  stage_name  = aws_api_gateway_stage.learning.stage_name
  method_path = "*/*"

  settings {
    throttling_rate_limit  = 10
    throttling_burst_limit = 100
  }
}


#
# --- Health resource ---
#
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id
  parent_id   = aws_api_gateway_rest_api.warehouse.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "get_health" {
  http_method      = "GET"
  resource_id      = aws_api_gateway_resource.health.id
  rest_api_id      = aws_api_gateway_rest_api.warehouse.id
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "health" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.get_health.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_method_response" "health_200" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.get_health.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_model.empty,
    aws_api_gateway_integration.health
  ]
}

resource "aws_api_gateway_model" "empty" {
  rest_api_id  = aws_api_gateway_rest_api.warehouse.id
  name         = "Empty"
  description  = "an Empty JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object"
}
EOF
}

resource "aws_api_gateway_integration_response" "health_200" {
  rest_api_id = aws_api_gateway_rest_api.warehouse.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.get_health.http_method
  status_code = "200"

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.health
  ]
}
