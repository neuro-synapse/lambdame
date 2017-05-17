resource "aws_iam_role" "shutdown_prod_role" {
  name = "shutdown_prod"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com","events.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "shutdown_prod" {
  filename         = "lambda/shutdown_prod.zip"
  function_name    = "shutdown_prod"
  role             = "${aws_iam_role.shutdown_prod_role.arn}"
  handler          = "shutdown_prod.lambda_handler"
  source_code_hash = "${base64sha256(file("lambda/shutdown_prod.zip"))}"
  runtime          = "python2.7"
  timeout          = 30
}

resource "aws_cloudwatch_event_rule" "shutdown_rule" {
  name                = "shutdown_prod_schedule"
  description         = "Schedule frequency to turn down instances tagged auto_shutdown"
  schedule_expression = "cron(0 12 * * ? *)"
}

resource "aws_cloudwatch_event_target" "shutdown_prod" {
  rule      = "${aws_cloudwatch_event_rule.shutdown_rule.name}"
  target_id = "shutdown_prod"
  arn       = "${aws_lambda_function.shutdown_prod.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.shutdown_prod.function_name}"
  principal     = "events.amazonaws.com"

  #source_arn = "arn:aws:events:us-east-1:465509206156:rule/shutdown_prod_schedule"
  source_arn = "${aws_cloudwatch_event_rule.shutdown_rule.arn}"
}

module "kinesis" {
  source               = "./kinesis"
  kinesis_name_var     = "gps-stream"
  retention_period_var = 24
}

#added information to branch
##testbranch from 
