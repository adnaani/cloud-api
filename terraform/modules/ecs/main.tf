resource "aws_ecs_cluster" "cloud_api" {
  name = "cloud-api-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name        = "cloud-api-cluster"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_ecs_task_definition" "cloud_api" {
  family                   = "cloud-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = var.execution_role_arn

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "cloud-api"
      image     = var.cloud_api_image
      essential = true
      portMappings = [
        {
          containerPort = var.cloud_api_container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

    }
  ])

  tags = {
    Name        = "cloud-api-task"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}
