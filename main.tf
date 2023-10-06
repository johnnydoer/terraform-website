resource "aws_s3_bucket" "s3-website-bucket" {
  bucket = var.s3-website-bucket-name # Specify a unique bucket name
}

resource "aws_s3_bucket_ownership_controls" "s3-website-bucket" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-website-bucket" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3-website-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3-website-bucket,
    aws_s3_bucket_public_access_block.s3-website-bucket,
  ]

  bucket = aws_s3_bucket.s3-website-bucket.id
  acl    = "public-read"
}
