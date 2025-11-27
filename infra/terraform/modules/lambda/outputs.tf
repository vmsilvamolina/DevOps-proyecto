output "lambda_url" {
  value = aws_lambda_function_url.handler_url.function_url
}