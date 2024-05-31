
resource "aws_cloudwatch_log_group" "cw_search" {
  retention_in_days = var.cloudwatch_log_retention
  name              = "${var.cluster_name}/search_slow_logs"
  kms_key_id        = var.cloudwatch_log_kms_key_id
}

resource "aws_cloudwatch_log_group" "cw_application" {
  retention_in_days = var.cloudwatch_log_retention
  name              = "${var.cluster_name}/application_logs"
  kms_key_id        = var.cloudwatch_log_kms_key_id
}

resource "aws_cloudwatch_log_group" "cw_audit" {
  retention_in_days = var.cloudwatch_log_retention
  name              = "${var.cluster_name}/audit_logs"
  kms_key_id        = var.cloudwatch_log_kms_key_id
}

data "aws_iam_policy_document" "cw_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.cw_index.arn}:*",
      "${aws_cloudwatch_log_group.cw_search.arn}:*",
      "${aws_cloudwatch_log_group.cw_application.arn}:*",
      "${aws_cloudwatch_log_group.cw_audit.arn}:*",
    ]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "cw_resource_policy" {
  policy_name     = "${var.cluster_name}-cw-policy"
  policy_document = data.aws_iam_policy_document.cw_policy.json
}