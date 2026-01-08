# S3 Bucket Creation

resource "aws_s3_bucket" "s3" {
  bucket = "rihads3"
}

# Hosted Zone Creation

resource "aws_route53_zone" "networking" {
  name = "networking.rihad.co.uk"
 }

# ECR Repo Creation

resource "aws_ecr_repository" "ecs-project" {
  name                 = "ecs-project"
}