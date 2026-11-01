# Troubleshooting

[Back to the project README](../README.md)

### TypeScript imports failed to compile

**Issue:** A relative import used `./app` with native ES Modules and `NodeNext` resolution. TypeScript reported that the import needed an explicit extension.

**Solution:** Use `./app.js` in the TypeScript source so the emitted JavaScript resolves correctly at runtime.

### Server startup was duplicated

**Issue:** Both `app.ts` and `server.ts` called `app.listen()`, making importing the application start a listener as a side effect.

**Solution:** Keep route definitions and the app export in `app.ts`; start the listener only in `server.ts`.

### Docker stages referenced different build paths

**Issue:** The builder compiled into `/build/dist`, but the runtime stage initially attempted to copy `/cloud-api/dist` from the builder.

**Solution:** Copy from `/build/dist`. Each stage has its own filesystem and working directory.

### The container ran as root

**Issue:** Running `whoami` in the image returned `root`.

**Solution:** Add `USER node` to the production stage, rebuild the image and verify the runtime user before retesting `/health`.

### The listener protocol did not match the intended setup

**Issue:** Terraform validation succeeded, but plan review revealed an HTTPS listener without a configured certificate, while the intended MVP used HTTP.

**Solution:** Change the listener protocol to HTTP and confirm port 80 in the plan. HTTPS requires its own certificate configuration and security review.

### The execution role trusted the wrong AWS service

**Issue:** The initial trust policy allowed `ec2.amazonaws.com` to assume a role intended for Fargate task execution.

**Solution:** Set the principal to `ecs-tasks.amazonaws.com`. This was caught during configuration review before deployment.

### ECS service deletion appeared stuck

**Observation:** During teardown, Terraform repeatedly reported that the ECS service was still destroying for several minutes.

**Explanation:** The target group used a 300-second deregistration delay. Connection draining and task cleanup can delay deletion; continued progress messages alone do not establish a failure. The teardown eventually completed successfully. During investigation, a read-only service status check can distinguish draining from errors without interrupting Terraform.

### Stale API output after targeted teardown

**Observation:** The apply summary still printed the old API URL after all 22 demo resources were destroyed.

**Explanation:** Targeted operations may leave outputs incompletely updated. The state listing contained only ECR; the old URL did not indicate a live ALB. A normal plan would propose recreating the runtime resources because their configuration remains in the repository.
