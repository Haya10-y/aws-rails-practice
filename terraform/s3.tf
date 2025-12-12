resource "aws_s3_bucket" "rails-test" {
  bucket = "haya10-s3-test-bucket-r03v"

  tags = {}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "rails-test" {
  bucket = aws_s3_bucket.rails-test.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "rails-test" {
  bucket = aws_s3_bucket.rails-test.id

  cors_rule {
    allowed_methods = ["PUT"]
    allowed_origins = ["http://localhost:3000"]
    allowed_headers = ["Content-Type", "Content-MD5", "Content-Disposition"]
    expose_headers  = []
    max_age_seconds = 3600
  }
}

resource "aws_s3_bucket_public_access_block" "rails-test" {
  bucket = aws_s3_bucket.rails-test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
