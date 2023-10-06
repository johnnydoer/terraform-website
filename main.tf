resource "aws_s3_bucket" "s3-website-bucket" {
  bucket = var.s3-website-bucket-name # Specify a unique bucket name
}
