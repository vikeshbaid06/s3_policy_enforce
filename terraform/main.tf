terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.53.0"
        }
    }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key = "terraform/policy_enfore_bucket/statefile.tfstate"
    region = "us-east-1"
  }
}

data "aws_iam_policy_document" "tls_enfore_policy" {
  statement {

    sid = "1"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
        "s3:*"
    ]

    effect = "Allow"

    resources = [
      aws_s3_bucket.s3_output_bucket.arn,
      "${aws_s3_bucket.s3_output_bucket.arn}/*",
    ]
  }
}