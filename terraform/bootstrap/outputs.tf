output "s3_bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "ecr_registry" {
  description = "URL of the Amazon ECR registry for pushing Docker images"
  value       = aws_ecr_repository.app.repository_url
}
