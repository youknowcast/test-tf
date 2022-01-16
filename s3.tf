# aws sts get-caller-identity --query 'Account' --output text
variable "aws_account_id" {
  type    = string
  default = ""
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "youknowcast-test-tf-alb-log"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
	  	var.aws_account_id
      ]
    }
  }
}