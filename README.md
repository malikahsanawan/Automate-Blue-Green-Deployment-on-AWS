# Blue-Green Deployment System

## Overview
This project demonstrates a production-ready Blue-Green deployment using Node.js, AWS (ALB, ECS/EKS, Route53), Terraform, and GitHub Actions.

**Architecture:**
- Load Balancer (AWS ALB or Nginx)
- Two parallel environments (Blue - v1 and Green - v2)
- Zero-downtime switch using health checks and Route53 updates

## Folder Structure
```
app/               # Node.js application
infra/             # Terraform IaC for AWS (modularized)
.github/workflows/ # GitHub Actions pipeline
```

## Tech Stack
- Node.js 20+, Express.js (example)
- Terraform 1.5+
- AWS: ALB, ECS Fargate or EKS, Route53, IAM, VPC
- Docker
- GitHub Actions (CI/CD)

## Getting Started

1. **Application**
    - Edit files in `/app/`
    - Run locally: `npm install && npm start`
2. **Infrastructure**
    - Edit files in `/infra/`
    - `terraform init`
    - `terraform plan -var-file=tfvars/dev.tfvars`
    - `terraform apply -var-file=tfvars/dev.tfvars`
    - USE CAUTION with `apply` for production
3. **CI/CD**
    - Push to main/dev branch triggers GitHub Actions (`.github/workflows/ci-cd.yml`)
    - Handles Docker image build, push, and Terraform deployment

## Security & Best Practices
- All secrets/environment config should be in GitHub Secrets or `*.tfvars` (never in code)
- Use OIDC or least-privilege IAM for GitHub Actions deployments
- Automated, tested, and peer-reviewed changes only

## License
MIT
