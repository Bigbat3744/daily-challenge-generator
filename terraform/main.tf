provider "aws" {
  region = "eu-west-2"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_lambda_function" "daily_challenge" {
  function_name    = "daily-challenge-generator"
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "aws_api_gateway_rest_api" "challenge_api" {
  name        = "DailyChallengeAPI"
  description = "Serves daily coding challenges"
}

resource "aws_api_gateway_resource" "challenge_resource" {
  rest_api_id = aws_api_gateway_rest_api.challenge_api.id
  parent_id   = aws_api_gateway_rest_api.challenge_api.root_resource_id
  path_part   = "challenge"
}

resource "aws_api_gateway_method" "get_challenge" {
  rest_api_id   = aws_api_gateway_rest_api.challenge_api.id
  resource_id   = aws_api_gateway_resource.challenge_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.challenge_api.id
  resource_id             = aws_api_gateway_resource.challenge_resource.id
  http_method             = aws_api_gateway_method.get_challenge.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.daily_challenge.invoke_arn
}

resource "aws_api_gateway_deployment" "challenge_deploy" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.challenge_api.id
}
resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.challenge_api.id
  deployment_id = aws_api_gateway_deployment.challenge_deploy.id
  stage_name    = "prod"
}
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_challenge.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.challenge_api.execution_arn}/*/*"
}
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}
resource "random_id" "suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "frontend" {
  bucket = "daily-challenge-frontend-${random_id.suffix.hex}"

  tags = {
    Name = "Frontend Hosting"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend_config" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
resource "aws_dynamodb_table" "challenges" {
  name           = "completed_challenges"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "ChallengeTracker"
    Environment = "Dev"
  }
}

