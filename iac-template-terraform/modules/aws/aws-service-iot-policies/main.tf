resource "aws_iot_policy" "connect_policy" {
  name   = var.name_policy_syn
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iot:Receive",
      "Resource": "arn:aws:iot:us-east-1:${var.aws_account_id}:topic/sync-*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Connect",
      "Resource": "arn:aws:iot:us-east-1:${var.aws_account_id}:client/*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Subscribe",
      "Resource": "arn:aws:iot:us-east-1:${var.aws_account_id}:topicfilter/sync-*"
    }
  ]
})
}

resource "aws_iot_policy" "publish_subscribe_policy" {
  name   = var.name_policy_notifier
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iot:Publish",
      "Resource": "arn:aws:iot:us-east-1:${var.aws_account_id}:topic/*"
    },
    {
      "Effect": "Allow",
      "Action": "iot:Connect",
      "Resource": "arn:aws:iot:us-east-1:${var.aws_account_id}:client/*"
    }
  ]
})
}
