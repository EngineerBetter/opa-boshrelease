provider "aws" {}

resource "aws_s3_bucket" "blobstore" {
  bucket        = "opa-blobstore"
  acl           = "public-read"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "blob-public-read" {
  bucket = aws_s3_bucket.blobstore.id

  policy = <<POLICY
{
  "Statement": [{
    "Action": [ "s3:GetObject" ],
    "Effect": "Allow",
    "Resource": "arn:aws:s3:::opa-blobstore/*",
    "Principal": { "AWS": ["*"] }
  }]
}
POLICY
}

resource "aws_s3_bucket" "releases" {
  bucket        = "opa-boshreleases"
  acl           = "public-read"
  force_destroy = true

  versioning {
    enabled = true
  }
}
