resource "aws_s3_bucket" "invoices_bucket" {
    bucket = "${var.project_name}-invoices_bucket-${var.account_id}-${var.region}"

    force_destroy = false
}

resource "aws_s3_bucket_lifecycle_configurationt" "invoices_bucket" {
    bucket = aws_s3_bucket.invoices_bucket.id

    rule {
        id = "archive-not-updated-lambda"

        transition {
            days  = 60
            storage_class= "STANDARD_IA"
        }
        status = "Enabled"
    }
}

resource "aws_s3_bucket_acl" "invoices_bucket" {
  bucket = aws_s3_bucket.invoices_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "invoices_bucket" {
  bucket = aws_s3_bucket.invoices_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "invoices_bucket" {
  bucket                  = aws_s3_bucket.invoices_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "invoices_bucket_s3_secure_transport" {
  bucket = aws_s3_bucket.invoices_bucket.id
  policy = data.aws_iam_policy_document.invoices_bucket_s3.json
}

data "aws_iam_policy_document" "invoices_bucket_s3" {
  statement {
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.invoices_bucket.arn}",
      "${aws_s3_bucket.invoices_bucket.arn}/*"
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