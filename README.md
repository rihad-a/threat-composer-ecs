# Threat Composer ECS

This project automates the deployment of the **Threat Composer Application** using **AWS ECS**, **Terraform**, **Docker**, and **CI/CD pipelines**. Originally set up manually using **AWS Console**, the process has been automated to provide a secure, scalable, and streamlined deployment.

The **Threat Composer Application** is a containerised React TypeScript application deployed on **AWS ECS Fargate**. This comprehensive threat modelling tool enables security professionals and architects to systematically identify, document, and mitigate threats to their systems.  tThe deployment process is fully automated using **CI/CD pipelines** to handle Docker image building, security scans, and deployment to AWShrough **Terraform**.

<br>

## Architecture Diagram

The architecture comprises the following AWS services working together to provide a highly available, scalable threat modelling platform:

- **ECS Fargate** for serverless container orchestration
- **Application Load Balancer (ALB)** for routing HTTPS traffic
- **Route 53** for custom domain name management and DNS
- **Security Groups** for network access control
- **VPC with public and private subnets** for network isolation
- **ECR (Elastic Container Registry)** for container image storage

<br>

## Key Components:

- **Dockerisation**: Multi-stage Docker build for optimised production builds and reduced image size.

- **Infrastructure as Code (IaC)**: Terraform provisions AWS resources for the bootstrap and deployment

- **CI/CD Pipeline**: GitHub Actions automate Docker image building, Terraform planning and deployment.

<br>

## Directory Structure

```
./
├── app
│   └── Dockerfile
├── terraform
│   ├── bootstrap
│   │   ├── main.tf
│   │   └── provider.tf
│   └── deployment
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── modules
│           ├── vpc
│           ├── alb
│           ├── ecs
│           └── route53
└── .github
    └── workflows
        ├── dockerimage-ecr.yml
        ├── terraformplan-pipeline.yml
        ├── terraformapply-pipeline.yml
        └── terraformdestroy-pipeline.yml
```

<br>



## Prerequisites

### 1. AWS Account Setup

Before deploying, ensure the following AWS prerequisites are met:

- **AWS Account**: An active AWS account with appropriate permissions
- **AWS CLI**: Installed and configured with credentials
- **Terraform**: Version 1.0 or later installed locally
- **Docker**: Installed for building and testing Docker images locally

### 2. GitHub Actions OIDC Configuration

To enable GitHub Actions workflows to authenticate securely with AWS, configure OpenID Connect (OIDC)

### 3. Domain Configuration

Before setting up Terraform, you'll need a domain and Cloudflare configuration:

- **Purchase Domain**: Register a domain through Cloudflare
- **Cloudflare Credentials**: Locally configure the following as environment variables:
    - **Cloudflare API Token**: Your Cloudflare API token for authentication
    - **Cloudflare Zone ID**: The zone ID for your domain in Cloudflare

### 4. Terraform Configuration

Before deploying, customise the Terraform variables:

- **Bootstrap Configuration** (`terraform/bootstrap/`):
    - Configure the domain name you purchased in Cloudflare within `main.tf`
    - Ensure your AWS CLI credentials are configured locally as environment variables

- **Deployment Configuration** (`terraform/deployment/`):
    - Update `terraform.tfvars` with your domain name and ECR Registry URL (from bootstrap output)
    - Update `provider.tf` with the S3 bucket name from bootstrap output (used for Terraform state backend)

### 5. GitHub Configuration

For automated CI/CD deployment:

- **GitHub Repository**: Repository with this project code
- **GitHub Secrets**: Configure the following secret:
    - `ECR_REPOSITORY`: The Amazon ECR registry URL from bootstrap output (e.g., `123456789012.dkr.ecr.eu-west-2.amazonaws.com/abcdefg`)

<br>

## CI/CD Deployment Workflow

The deployment process is fully automated via GitHub Actions:

1. **Docker Image Build & Deployment** (`dockerimage-ecr.yml`):
    - Builds the Docker image using the multi-stage Dockerfile
    - Runs **Trivy** to scan for vulnerabilities before pushing to ECR
    - Pushes the image to **Amazon ECR**

2. **Terraform Plan** (`terraformplan-pipeline.yml`):
    - Initialises the Terraform directory
    - Previews the necessary AWS resources (VPC, ALB, ECS, Route 53)

3. **Terraform Apply** (`terraformapply-pipeline.yml`):
    - Initialises the Terraform directory
    - Provisions the necessary AWS resources

4. **Terraform Destroy** (`terraformdestroy-pipeline.yml`):
    - Destroys all Terraform-managed resources

To trigger any of these workflows, go to **GitHub Actions** and manually run the desired workflow.

<br>

## Deployment Steps

### Step 1: Bootstrap the AWS Environment

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

Note the outputs from the bootstrap phase:
- **S3 Bucket Name**: Used for storing Terraform state files
- **ECR Registry URL**: The Amazon ECR repository URL for Docker images (required for Step 2)

### Step 2: Configure GitHub Actions Secrets

In your GitHub repository settings:
1. Go to **Settings** → **Secrets and variables** → **Actions** → **Secrets**
2. Create the following secret:
   - `ECR_REPOSITORY`: The ECR Registry URL from Step 1 bootstrap output

### Step 3: Deploy Infrastructure

1. Navigate to **GitHub Actions** in your repository
2. Click **Running a Terraform Plan**
3. Click **Run workflow**
4. Once review is complete, click **Terraform Apply**
5. Click **Run workflow**

### Step 4: Update Application Code (Optional)

When ready to deploy application updates:
1. Make changes to files in the `app/` directory
2. Commit and push to the `main` branch
3. The Docker build pipeline automatically triggers
4. Trivy scans the image for vulnerabilities
5. Image is pushed to ECR
6. ECS service is updated with the new image (manual or via auto-rollout)

### Step 5: Access the Application

Once deployed:
- **Via ALB DNS**: Access through the Application Load Balancer DNS name (shown in Terraform output)
- **Via Custom Domain**: If configured, access through your Route 53 custom domain with HTTPS
- **Health Check**: Application exposes health check endpoint at `/health`

<br>
