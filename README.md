# Cloud API

A small TypeScript Express REST API and portfolio project for learning Docker, AWS and Terraform.

The API currently runs locally and in Docker. AWS infrastructure and deployment are planned for later milestones.

## Endpoints

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/` | Returns a welcome message |
| GET | `/health` | Returns service health and a dynamically generated timestamp |
| GET | `/info` | Returns the application name and version |

## Run locally

Prerequisites: Node.js 22 and npm. The Docker image also uses Node.js 22.

From the project directory, install dependencies using the lockfile:

```bash
npm ci
```

Start the development server with automatic reload:

```bash
npm run dev
```

The API listens on `http://localhost:3000`. Stop it with `Ctrl+C`.

To compile TypeScript and run the compiled application:

```bash
npm run build
npm start
```

The server binds to `0.0.0.0` and defaults to port `3000`. Override the port with the `PORT` environment variable, for example:

```bash
PORT=3001 npm start
```

## Tests

Run the endpoint tests with Node's test runner and Supertest:

```bash
npm test
```

The tests cover all three endpoints, including the health response's timestamp format. They start temporary HTTP servers, so the environment must allow local port binding.

## Run with Docker

Prerequisite: Docker installed and running.

Build the image from the project directory:

```bash
docker build -t cloud-api:local .
```

The multi-stage build compiles TypeScript in the builder stage. The runtime stage contains production dependencies and the compiled application, and runs as the non-root `node` user.

Start the container:

```bash
docker run --rm --name cloud-api -p 3001:3000 cloud-api:local
```

The port mapping exposes container port `3000` on your machine at port `3001`. Open `http://localhost:3001`, or use curl from another terminal:

```bash
curl http://localhost:3001/
curl http://localhost:3001/health
curl http://localhost:3001/info
```

Example health response:

```json
{
  "status": "healthy",
  "service": "cloud-api",
  "timestamp": "2026-10-26T14:23:24.572Z"
}
```

The timestamp changes with each request. Stop the container with `Ctrl+C`; `--rm` removes the stopped container.

To check the image's runtime user:

```bash
docker run --rm cloud-api:local whoami
```

Expected output: `node`.

## Project structure

```text
src/app.ts        Express application and routes
src/server.ts     Port configuration and server startup
tests/app.test.ts Endpoint tests
Dockerfile        Multi-stage container build
.dockerignore     Files excluded from the Docker build context
tsconfig.json     TypeScript compiler configuration
```

## Planned milestones

- Provision AWS networking, IAM and ECR with Terraform.
- Deploy to ECS Fargate behind an Application Load Balancer.
- Add logging, infrastructure health checks, security and cost controls.
- Add S3 remote Terraform state and GitHub Actions with AWS OIDC authentication.
