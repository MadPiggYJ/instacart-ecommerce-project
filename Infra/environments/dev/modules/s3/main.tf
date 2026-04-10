resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.bucket_versioning != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.bucket_versioning
  }
}