#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#Create S3 bucket for artifacts
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "terraform-project325"

  acl           = "private"
  force_destroy = true
}

#Create role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

#attach policy to role
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.iam_for_lambda.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSEC2Access" {
    role       = aws_iam_role.iam_for_lambda.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "archive_file" "lambda_code_deploy" {
  type = "zip"

  source_dir  = "${path.module}/Lambda"
  output_path = "${path.module}/Lambda.zip"
}

resource "aws_s3_bucket_object" "lambda_code_deploy" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "Lambda.zip"
  source = data.archive_file.lambda_code_deploy.output_path

  etag = filemd5(data.archive_file.lambda_code_deploy.output_path)
}

resource "aws_lambda_function" "lambda_code_deploy" {
  function_name = "Reaper"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_code_deploy.key

  runtime = "nodejs14.x"
  handler = "reaper.handler"
  timeout = "60"

  source_code_hash = data.archive_file.lambda_code_deploy.output_base64sha256
  role = aws_iam_role.iam_for_lambda.arn
}

resource "aws_cloudwatch_log_group" "reaper_function" {
 name = "/aws/lambda/${aws_lambda_function.lambda_code_deploy.function_name}"

  retention_in_days = 30
}