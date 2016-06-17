resource "aws_cloudwatch_event_rule" "lambda" {
  name        = "apex-auto-delete-snapshot"
  description = "apex auto delete snapshot"

  event_pattern = <<EOT
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "DeregisterImage"
    ]
  }
}
EOT
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  target_id = "apex-auto-delete-snapshot"
  arn       = "arn:aws:lambda:${var.aws_region}:${element(split(":", var.lambda_function_role_id), 4)}:function:apex-auto-delete-snapshot"
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_cloudwatch_event_target.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}
