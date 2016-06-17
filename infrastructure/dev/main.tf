module "iam" {
  source = "../modules/iam"
}

module "cloudwatch_events" {
  source = "../modules/cloudwatch_events"

  aws_region              = "${var.aws_region}"
  lambda_function_role_id = "${module.iam.lambda_function_role_id}"
}
