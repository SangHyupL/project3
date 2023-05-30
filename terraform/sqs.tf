resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terr-stock-q"
  delay_seconds             = 0
  max_message_size          = 256000
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terr_queue_dlq.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "terr_queue_dlq" {
  name = "terr-stock-dlq-queue"
  delay_seconds             = 0
  max_message_size          = 256000
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name = "stock_empty2"
}

# SNS 구독 SNS -> SQS
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = module.sns_topic.sns_topic_arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.terraform_queue.arn
}
