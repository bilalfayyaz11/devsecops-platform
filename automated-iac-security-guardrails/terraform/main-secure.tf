terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_secure" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "main-secure-vpc"
    Environment = "lab"
  }
}

resource "aws_s3_bucket" "secure_example" {
  bucket = "my-secure-bucket-${random_string.secure_bucket_suffix.result}"
  tags = {
    Name        = "SecureExampleBucket"
    Environment = "lab"
  }
}

resource "aws_s3_bucket_public_access_block" "secure_example" {
  bucket = aws_s3_bucket.secure_example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_example" {
  bucket = aws_s3_bucket.secure_example.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "secure_example" {
  bucket = aws_s3_bucket.secure_example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_string" "secure_bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
