# Lessons Learned

[Back to the project README](../README.md)

- A valid Terraform configuration can still express the wrong design. Review actual protocols, principals and resource references in addition to checking resource counts.
- A subnet becomes public through its route to an internet gateway. Naming it `public` or enabling automatic public IP assignment does not establish that route.
- Security group rules and network routes solve different problems: routes establish paths, while security groups control permitted traffic.
- AWS CLI authentication does not automatically authenticate Docker to ECR. Docker requires a registry login before pushing or pulling private images.
- Image architecture is part of deployment compatibility. A working ARM64 image needs matching runtime configuration.
- An environment tag labels resources; it does not provide separate infrastructure, names or Terraform state.
- Small commits preserve the reasoning behind each infrastructure step, even when several steps are eventually deployed together.

## Refactoring Terraform modules

The project was split into seven modules as the configuration grew. This was an early maintainability improvement, not a response to a production outage. The deployed ECR state address was migrated with `terraform state mv`; a subsequent plan showed no ECR changes or destruction. The other resources were still pending at the time.

Sibling modules communicate through root module inputs and outputs. Explicit dependencies were added where IDs alone did not express the requirement for listeners, policy attachments, routes and security rules to be ready before task startup.

## Verification and cost control

An apply completing is not proof of application health. The verification session combined public HTTP responses, ECS service status and events, ALB target health, CloudWatch output and a clean post-deployment Terraform plan. The no-drift result applies to that check, not to all future infrastructure changes.

After capturing evidence, the runtime resources were destroyed while ECR and the image were retained. Reproducible infrastructure makes short deployment sessions practical; it does not remove the need to review costs, destruction scope and state backups.

## Project journey

1. **Application foundation — complete:** Built and tested the three Express endpoints, configured TypeScript ES Modules and separated app setup from startup.
2. **Containerisation — complete:** Created a multi-stage Dockerfile, verified port mapping and ran the API as a non-root user.
3. **Image registry — complete:** Provisioned ECR, pushed `v1`, pulled it back and verified the health endpoint locally.
4. **Networking and security — verified:** Provisioned the VPC, subnets, routing and ALB/ECS security groups for the AWS demo.
5. **Load balancing and IAM — verified:** Deployed the ALB, listener, target group and execution role; all public API endpoints returned HTTP 200.
6. **Logging, ECS and teardown — verified:** Ran the ARM64 task on Fargate, checked service health and CloudWatch output, confirmed a clean Terraform plan, then destroyed the 22 demo resources while retaining ECR.
7. **Delivery automation — later:** Introduce remote Terraform state and GitHub Actions with AWS OIDC authentication.
