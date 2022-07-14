#
#   S3 Buckets for core management
#


# -------- LAMBDA PACKAGES ---------
# Bucket for storing all the lambda 
# zip build to be deployed.
# 
resource "aws_s3_bucket" "lambda_packages" {
  bucket = "${var.project_name}-lambda-packages-${var.account_id}-${var.region}"

  force_destroy = false
}

resource "aws_s3_bucket_lifecycle_configuration" "lambda_packages" {
  bucket = aws_s3_bucket.lambda_packages.id

  rule {
    id = "archive-not-updated-lambda"

    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "lambda_packages" {
  bucket = aws_s3_bucket.lambda_packages.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_packages" {
  bucket = aws_s3_bucket.lambda_packages.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_packages" {
  bucket                  = aws_s3_bucket.lambda_packages.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#
# Allow only access secured with HTTPS protocol
#
resource "aws_s3_bucket_policy" "lambda_packages_s3_secure_transport" {
  bucket = aws_s3_bucket.lambda_packages.id
  policy = data.aws_iam_policy_document.lambda_packages_s3.json
}

data "aws_iam_policy_document" "lambda_packages_s3" {
  statement {
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.lambda_packages.arn}",
      "${aws_s3_bucket.lambda_packages.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
