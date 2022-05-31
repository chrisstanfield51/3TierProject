output "s3_bucket_id" {
  value = aws_s3_bucket.site.id
}

output "CloudfrontID" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name

}