data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/handler.py"
  output_path = "${path.module}/handler.zip"
}


resource "aws_lambda_function" "handler" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  function_name = var.lambda_name
  role          = data.aws_iam_role.lab_role.arn

  # handler.py + función lambda_handler = handler.lambda_handler
  handler = "handler.lambda_handler"

  runtime = "python3.11"
  timeout = 10
}

resource "aws_lambda_function_url" "handler_url" {
  function_name      = aws_lambda_function.handler.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "allow_function_url" {
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.handler.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}