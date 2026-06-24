output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}
