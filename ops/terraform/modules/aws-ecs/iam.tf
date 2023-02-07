data "aws_iam_policy_document" "iam_policy_assume_role_ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

## Execution Task Role
resource "aws_iam_role" "iam_role_ecs_task_execution_role" {
  name               = "${local.environment}-${local.service_name}-ecs-task-execution-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.iam_policy_assume_role_ecs.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_task_execution_assume_role" {
  role       = aws_iam_role.iam_role_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## Task Execution Role
data "aws_iam_policy_document" "iam_policy_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = (var.secrets_manager_arn != "" && var.sensitive_secrets_arn != "") ? [var.secrets_manager_arn, var.sensitive_secrets_arn] : [var.secrets_manager_arn]
  }
}

# Only create if task uses secrets from secrets manager
resource "aws_iam_policy" "iam_policy_secrets_manager_read" {
  count       = var.task_secrets_enabled ? 1 : 0
  name        = "${local.environment}-${local.resource_name_prefix}-secrets-manager-read"
  path        = "/"
  description = "Allow task definition to read secrets from secrets manager and put them in env variables"

  policy = data.aws_iam_policy_document.iam_policy_secrets_manager.json
}

# Only create if task uses secrets from secrets manager
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_task_execution_role_secrets_manager_read" {
  count      = var.task_secrets_enabled ? 1 : 0
  role       = aws_iam_role.iam_role_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.iam_policy_secrets_manager_read[0].arn
}

## Task Role
data "aws_iam_policy_document" "iam_policy_cloudwatch_log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:${var.aws_cloudwatch_logs_group}:*"]
  }
}

resource "aws_iam_policy" "iam_policy_cloudwatch_log_publishing" {
  name        = "${local.environment}-${local.service_name}-cloudwatch-logs-publishing-iam-policy"
  path        = "/"
  description = "Allow publishing to cloudwach"

  policy = data.aws_iam_policy_document.iam_policy_cloudwatch_log_publishing.json
}

resource "aws_iam_role" "iam_role_ecs_task_role" {
  name               = "${local.environment}-${local.service_name}-ecs-task-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.iam_policy_assume_role_ecs.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_task_role_cloudwatch_log_publishing" {
  role       = aws_iam_role.iam_role_ecs_task_role.name
  policy_arn = aws_iam_policy.iam_policy_cloudwatch_log_publishing.arn
}