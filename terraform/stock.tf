# 현재 호출자, ID 값을 가져오기 위한 데이터
data "aws_caller_identity" "current" {}

# 현재 사용중인 Region 정보를 가져오기 위한 데이터
data "aws_region" "current" {}

resource "aws_lambda_function" "stock_lambda" {
  function_name    = "stock"
  filename         = data.archive_file.lambda_zip_file_stock.output_path
  source_code_hash = data.archive_file.lambda_zip_file_stock.output_base64sha256
  handler          = "index.handler"
  role             = aws_iam_role.stock_lambda_role2.arn
  runtime          = "nodejs14.x"
  timeout          = 6

  environment {
    variables = {
      increase_ENDPOINT = var.callback_ENDPOINT
    }
  }
}

# 소스파일 zip 압축
data "archive_file" "lambda_zip_file_stock" {
  type        = "zip"
  source_dir  = "${path.module}/stock"
  output_path = "${path.module}/stock_lambda.zip"
}

#stock_increase_lambda
resource "aws_lambda_function" "stock_increase_lambda" {
  function_name    = "stock_increase"
  filename         = data.archive_file.lambda_zip_file_stock_increase.output_path
  source_code_hash = data.archive_file.lambda_zip_file_stock_increase.output_base64sha256
  handler          = "handler.handler"
  role             = aws_iam_role.lambda_iam_role3.arn
  runtime          = "nodejs14.x"
  timeout          = 6

  environment {
    variables = {
      DB_HOST = var.DB_HOSTNAME
      DB_USER = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD
      DATABASE = var.DB_DATABASE
    }
  }
}

# 소스파일 zip 압축
data "archive_file" "lambda_zip_file_stock_increase" {
  type        = "zip"
  source_dir  = "${path.module}/stock_increase"
  output_path = "${path.module}/stock_increase_lambda.zip"
}
