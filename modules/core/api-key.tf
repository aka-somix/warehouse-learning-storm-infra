resource "aws_api_gateway_api_key" "learning" {
  name = "learning-key"
}

resource "aws_api_gateway_usage_plan" "learning" {
  name = "learning-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.warehouse.id
    stage  = aws_api_gateway_stage.learning.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.learning.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.learning.id
}
