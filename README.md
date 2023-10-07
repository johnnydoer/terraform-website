**README.md**

# AWS S3 Website Deployment

This repository contains Terraform code to set up an AWS S3 bucket for hosting a static website. The infrastructure is designed to host an awesome portfolio website. Below are the details of the resources and their configurations used in this setup.

## Terraform Resources

### 1. **S3 Bucket for Website Hosting**

A new S3 bucket is created with the specified unique name to host the static website files.

```hcl
resource "aws_s3_bucket" "s3-website-bucket" {
  bucket = var.s3-website-bucket-name # Specify a unique bucket name
}
```

### 2. **S3 Bucket Ownership Controls**

Ownership controls are configured to ensure that object ownership is set to "BucketOwnerPreferred."

```hcl
resource "aws_s3_bucket_ownership_controls" "s3-website-bucket" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```

### 3. **Public Access Block**

Public access is allowed for the objects inside the S3 bucket, enabling public read access.

```hcl
resource "aws_s3_bucket_public_access_block" "s3-website-bucket" {
  bucket = aws_s3_bucket.s3-website-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

### 4. **Bucket Access Control List (ACL)**

The S3 bucket's access control list is configured to allow public read access to the objects.

```hcl
resource "aws_s3_bucket_acl" "s3-website-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3-website-bucket,
    aws_s3_bucket_public_access_block.s3-website-bucket,
  ]

  bucket = aws_s3_bucket.s3-website-bucket.id
  acl    = "public-read"
}
```

### 5. **Module for Template Files**

A Terraform module is used to manage files for the awesome portfolio websites. The module ensures proper handling of content types and ACL settings.

```hcl
module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/awesome-portfolio-websites"
}
```

### 6. **S3 Objects**

Individual objects (files) are uploaded to the S3 bucket using a loop. The content type and ACL settings are derived from the files provided by the `template_files` module. Check out the documentation [here](https://registry.terraform.io/modules/hashicorp/dir/template/latest). 

```hcl
resource "aws_s3_object" "portfolio" {
  for_each = module.template_files.files

  bucket = aws_s3_bucket.s3-website-bucket.id
  key          = each.key
  content_type = each.value.content_type
  acl = "public-read"

  source  = each.value.source_path
  content = each.value.content
}
```

## How to Use

1. Ensure you have Terraform installed on your system.
2. Edit the `variables.tf` file and specify the `s3-website-bucket-name` variable with your desired bucket name.
3. Run `terraform init` to initialize the Terraform configuration.
4. Run `terraform apply` to create the S3 bucket and deploy the website files.

**Note:** Ensure your AWS credentials are properly configured to allow Terraform to create and manage resources in your AWS account.

Feel free to customize the `awesome-portfolio-websites` directory inside the module to add your own website files and templates.

Happy coding!

## Reference
The portfolio website code can be found at [smaranjitghose/awesome-portfolio-websites](https://github.com/smaranjitghose/awesome-portfolio-websites).
