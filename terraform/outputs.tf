output "api_url" {
  value = "https://${aws_api_gateway_rest_api.challenge_api.id}.execute-api.${var.region}.amazonaws.com/prod/challenge"
}
output "s3_website_url" {
  description = "S3 static website URL"
  value       = aws_s3_bucket_website_configuration.frontend_config.website_endpoint
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.challenges.name
}

#output "lambda_function_name" {
#  description = "Name of the Lambda function"
#  value       = aws_lambda_function.challenge_picker.function_name
#}

