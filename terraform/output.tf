output "TopicPublisherFunction" {
  value       = aws_lambda_function.lambda_function.arn
  description = "TopicPublisherFunction function name"
}

output "SNStopicARN" {
  value       = module.sns_topic.sns_topic_arn
  description = "SNS topic ARN"
}
