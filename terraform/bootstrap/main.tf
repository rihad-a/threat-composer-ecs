# S3 Bucket Creation

resource "aws_s3_bucket" "s3" {
  bucket = "rihads3"
}

resource "aws_s3_bucket_versioning" "rihads3" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "rihads3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Hosted Zone Creation

resource "aws_route53_zone" "networking" {
  name = "networking.rihad.co.uk"
 }

output "ns" {
  value = "${aws_route53_zone.networking.name_servers}"
 }

## Linkage Of Route53 Hosted Zone NS' to Cloudflare

 resource "cloudflare_dns_record" "route53-ns" {
  name    = "networking"
  count   = "${length(aws_route53_zone.networking.name_servers)}"
  ttl     = 300
  type    = "NS"
  content   = "${element(aws_route53_zone.networking.name_servers, count.index)}"
  zone_id = "415c05da9144abf5a32a57c25dfefe06"
}

# ECR Repo Creation

resource "aws_ecr_repository" "ecs-project" {
  name                 = "ecs-project"
}