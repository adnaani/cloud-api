# Deployment, Registry and Teardown

[Back to the project README](../README.md)

## Current status

On 1 November 2026, Terraform created 22 demo resources alongside the existing ECR repository. The API was verified through the ALB, then the 22 resources were destroyed. Only ECR remains managed in local state. The old public endpoint is no longer live.

## Terraform workflow

Prerequisites: Terraform 1.5 or newer, AWS CLI with credentials for the intended account, and permission to manage the project resources. The AWS provider uses the `eu-west-2` (London) region.

Confirm the AWS identity before working with infrastructure:

```bash
aws sts get-caller-identity
```

Initialise the working directory, check formatting and validate the configuration:

```bash
terraform -chdir=terraform init
terraform -chdir=terraform fmt -recursive -check
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

These commands do not provision resources. Review every plan before applying. Applying the current configuration will create the pending resources, including a billable ALB; it is not limited to the existing ECR repository. The demo has been torn down, so a normal apply would recreate its 22 resources and resume ongoing charges.

The `environment` input variable defaults to `dev` and is used for resource tags. It does not create isolated environments or separate state files. To preview a different label:

```bash
terraform -chdir=terraform plan -var="environment=demo"
```

Terraform currently uses local state. Keep state files, the `.terraform/` directory and credentials out of Git; commit `.terraform.lock.hcl` to retain the selected provider version. Preserve local state because it records the resources Terraform manages. An S3 remote backend is planned for a later milestone.

## Deploy for a verification session

After reviewing the plan, costs and teardown scope:

```bash
terraform -chdir=terraform apply
```

An apply starts billable ALB, Fargate and public IPv4 usage. The ECS service does not wait for steady state during apply; verify the service separately.

```bash
API_URL=$(terraform -chdir=terraform output -raw api_url)
curl -i --max-time 15 "$API_URL/"
curl -i --max-time 15 "$API_URL/health"
curl -i --max-time 15 "$API_URL/info"

aws ecs describe-services \
  --cluster cloud-api-cluster \
  --services cloud-api-service \
  --region eu-west-2 \
  --query 'services[0].{desired:desiredCount,running:runningCount,pending:pendingCount,deployments:deployments[*].{status:status,rollout:rolloutState}}'

aws logs tail /ecs/cloud-api --since 10m --region eu-west-2
terraform -chdir=terraform plan
```

Expected results: all endpoints return HTTP 200, one task is running with zero pending, the primary rollout completes, startup logs are available and Terraform reports no changes. Also inspect ALB target health in the AWS console.

## Container registry

The ECR repository uses immutable image tags and scanning on push. Each new image version needs a new tag; an existing tag such as `v1` cannot be overwritten.

From the project root, obtain the repository URL from Terraform and authenticate Docker to its registry:

```bash
ECR_REPOSITORY_URL=$(terraform -chdir=terraform output -raw ecr_repository_url)
ECR_REGISTRY=${ECR_REPOSITORY_URL%/*}

aws ecr get-login-password --region eu-west-2 \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY"
```

To publish an image, choose an unused version tag:

```bash
IMAGE_TAG=v2
docker tag cloud-api:local "$ECR_REPOSITORY_URL:$IMAGE_TAG"
docker push "$ECR_REPOSITORY_URL:$IMAGE_TAG"
```

Verify the uploaded image locally:

```bash
docker run --rm --pull=always --name cloud-api-ecr \
  -p 3002:3000 "$ECR_REPOSITORY_URL:$IMAGE_TAG"
```

In another terminal, run `curl http://localhost:3002/health`. Stop the container with `Ctrl+C` after testing.

The existing `v1` image targets `linux/arm64`. The Fargate task definition selects ARM64 to match this image.

## Teardown while preserving ECR

The demo used an exceptional targeted teardown to preserve ECR in the same state. Targeting is not the routine deployment workflow. A future improvement is to separate persistent registry state from disposable runtime state.

Save any evidence first: this teardown deletes the CloudWatch log group. Back up state into a Git-ignored file and restrict its permissions:

```bash
terraform -chdir=terraform state pull > terraform-state-backup.tfstate
chmod 600 terraform-state-backup.tfstate

terraform -chdir=terraform plan -destroy \
  -target=module.ecs \
  -target=module.alb \
  -target=module.security \
  -target=module.networking \
  -target=module.iam \
  -target=module.logging \
  -out=/tmp/cloud-api-teardown.tfplan
```

Review the saved plan: for the current configuration, expect 22 destructions and **no ECR destruction**. Only after reviewing it, execute the saved plan:

```bash
terraform -chdir=terraform apply /tmp/cloud-api-teardown.tfplan
terraform -chdir=terraform state list
```

Applying a saved plan executes it without another approval prompt. The expected remaining state entry is `module.ecr.aws_ecr_repository.cloud_api`. Keep state, backups and saved plans out of version control. A subsequent normal plan proposes recreating the runtime resources; do not apply it unless redeployment is intended. ECR image storage continues to incur charges after runtime teardown.
