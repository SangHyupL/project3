data "aws_iam_policy" "lambda_basic_execution_role_policy" {
  name = "AWSLambdaBasicExecutionRole"
}

# Role to execute lambda
resource "aws_iam_role" "lambda_iam_role" {
  name               = "stock_lambda_role"
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
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# sns 역할, 정책 생성
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {

    effect = "Allow"

    actions = [
      "sns:*"
    ]

    resources = [
      module.sns_topic.sns_topic_arn
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

resource "aws_iam_policy_attachment" "attach_lambda_iam_policy" {
  name       = "lambda-policy-attachment"
  roles      = [aws_iam_role.lambda_iam_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function_event_invoke_config" "sns_topic" {
  function_name = aws_lambda_function.lambda_function.function_name

  destination_config {

    on_success {
      destination = module.sns_topic.sns_topic_arn
    }
  }
}

# SNS to SQS 정책 생성
resource "aws_sqs_queue_policy" "sns_sqs_sqspolicy" {
  queue_url = aws_sqs_queue.terraform_queue.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sns_sqs_policy",
  "Statement": [
    {
      "Sid": "Allow SNS publish to SQS",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.terraform_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${module.sns_topic.sns_topic_arn}"
        }
      }
    }
  ]
}
EOF
}
