# Lambda 선언
resource "aws_lambda_function" "lambda_function" {
  function_name    = "sales-api2"
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  handler          = "handler.handler"
  role             = aws_iam_role.lambda_iam_role.arn
  runtime          = "nodejs14.x"
  timeout          = 6

  environment {
    variables = {
      DB_HOST = var.DB_HOSTNAME
      DB_USER = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD
      DATABASE = var.DB_DATABASE
      TOPIC_ARN = module.sns_topic.sns_topic_arn
    }
  }
}

data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_dir = "${path.module}/src"
  output_path = "${path.module}/lambda.zip"
}
