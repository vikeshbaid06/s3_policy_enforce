resource "aws_s3_bucket" "s3_output_bucket" {
    bucket = var.s3_output_bucket
}

# resource "aws_s3_bucket_public_access_block" "metrics_bucket_block_public" {
#     bucket = aws_s3_bucket.s3_output_bucket.id

#     block_public_acls = true
#     block_public_policy = true
#     ignore_public_acls = true
#     restrict_public_buckets = true
# }

# resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
#     bucket = aws_s3_bucket.s3_output_bucket.id

#     rule {
#         object_ownership = "BucketOwnerPreferred"
#     }
# }