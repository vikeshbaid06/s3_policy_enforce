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

# data "aws_iam_policy_document" "tls_enfore_policy" {
#   statement {

#     actions = [
#         "s3:*"
#     ]
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     resources = [
#       aws_s3_bucket.s3_output_bucket.arn,
#       "${aws_s3_bucket.s3_output_bucket.arn}/*",
#     ]
#   }
# }

# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = aws_s3_bucket.s3_output_bucket.id
#   policy = data.aws_iam_policy_document.tls_enfore_policy.json
# }

resource "aws_s3_bucket_policy" "tls_enforce_policy" {
    bucket = aws_s3_bucket.s3_output_bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "BUCKET-POLICY"
        Statement = [
            {
                Sid       = "EnforceTls"
                Effect    = "Deny"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.test_s3_bucket.arn}/*",
                    "${aws_s3_bucket.test_s3_bucket.arn}",
                ]
                Condition = {
                    Bool = {
                        "aws:SecureTransport" = "false"
                    }
                }
            },
            {
                Sid       = "EnforceProtoVer"
                Effect    = "Deny"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.test_s3_bucket.arn}/*",
                    "${aws_s3_bucket.test_s3_bucket.arn}",
                ]
                Condition = {
                    NumericLessThan = {
                        "s3:TlsVersion": 1.2
                    }
                }
            }
        ]
    })
}