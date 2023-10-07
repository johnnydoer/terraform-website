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

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/awesome-portfolio-websites"
}

resource "aws_s3_object" "portfolio" {
  for_each = module.template_files.files

  bucket = aws_s3_bucket.s3-website-bucket.id
  key          = each.key
  content_type = each.value.content_type

  # The template_files module guarantees that only one of these two attributes
  # will be set for each file, depending on whether it is an in-memory template
  # rendering result or a static file on disk.
  source  = each.value.source_path
  content = each.value.content

  # Unless the bucket has encryption enabled, the ETag of each object is an
  # MD5 hash of that object.
 
}
