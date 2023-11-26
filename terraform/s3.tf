resource "aws_s3_bucket" "s3_output_bucket" {
    bucket = var.s3_output_bucket
    tags = {
        component = var.component_tag
    }
}

resource "aws_s3_bucket_public_access_block" "bucket_block_public" {
    bucket = aws_s3_bucket.s3_output_bucket.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
    bucket = aws_s3_bucket.s3_output_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
    depends_on = [aws_s3_bucket_public_access_block.bucket_block_public]
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

resource "aws_s3_bucket_policy" "prod_media_bucket" {
    bucket = aws_s3_bucket.s3_output_bucket.id
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
            aws_s3_bucket.s3_output_bucket.arn,
            "${aws_s3_bucket.s3_output_bucket.arn}/*"
        ]
      },
      {
        Sid = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
            aws_s3_bucket.s3_output_bucket.arn,
            "${aws_s3_bucket.s3_output_bucket.arn}/*"
        ]
      },
    ]
  })
}