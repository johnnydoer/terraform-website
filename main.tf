resource "aws_s3_bucket" "s3-website-bucket" {
  bucket = var.s3-website-bucket-name # Specify a unique bucket name
}

resource "aws_s3_bucket_ownership_controls" "s3-website-bucket" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

