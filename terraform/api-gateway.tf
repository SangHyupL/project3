module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "lambda2http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  create_api_domain_name           = false
  # Routes and integrations
  integrations = {
    "$default" = {
      lambda_arn = "${aws_lambda_function.lambda_function.arn}"
      payload_format_version = "2.0"
    }
  }
}

# Attach API Gateway to Lambda 
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*"
}


module "api_gateway_increase" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "lambda3http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  create_api_domain_name           = false
  # Routes and integrations
  integrations = {
    "$default" = {
      lambda_arn = "${aws_lambda_function.stock_increase_lambda.arn}"
      payload_format_version = "2.0"
    }
  }
}

# Attach API Gateway to Lambda-increase
resource "aws_lambda_permission" "api_gw_increase" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stock_increase_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway_increase.apigatewayv2_api_execution_arn}/*"
}
