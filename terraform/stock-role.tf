# Role to execute lambda
resource "aws_iam_role" "stock_lambda_role2" {
  name               = "stock_lambda_role2"
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

# CloudWatch Log group to store Lambda logs
resource "aws_cloudwatch_log_group" "stock_lambda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.stock_lambda.function_name}"
  retention_in_days = 14
}

# CloudWatch Log group to store Lambda logs
resource "aws_cloudwatch_log_group" "stock_increase_lambda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.stock_increase_lambda.function_name}"
  retention_in_days = 14
}

# Custom policy to read SQS queue and write to CloudWatch Logs with least privileges
resource "aws_iam_policy" "stock_lambda_policy" {   
  name        = "stock_lambda_policy"
  path        = "/"
  description = "Policy for sqs to lambda demo"
  policy      = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": "${aws_sqs_queue.terraform_queue.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.stock_lambda.function_name}:*:*"
    }
  ]
}
EOF
}

# 위에서 작성된 IAM ROLE을 정책에 연결
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.stock_lambda_role2.name
  policy_arn = aws_iam_policy.stock_lambda_policy.arn
}

# 이벤트 소스 매핑
resource "aws_lambda_event_source_mapping" "sqs_lambda_source_mapping" {
  event_source_arn = aws_sqs_queue.terraform_queue.arn
  function_name    = aws_lambda_function.stock_lambda.function_name
}

# increase_lambda policy
data "aws_iam_policy" "lambda_basic_execution_role_policy2" {
  name = "AWSLambdaBasicExecutionRole"
}

# Role to execute increase_lambda
resource "aws_iam_role" "lambda_iam_role3" {
  name               = "stock_lambda_role3"
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

# lambda 실행역할, 정책 연결
resource "aws_iam_role_policy_attachment" "lambda_policy2" {
  role       = aws_iam_role.lambda_iam_role3.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
