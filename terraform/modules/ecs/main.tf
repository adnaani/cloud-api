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

resource "aws_ecs_service" "cloud_api" {
  name                              = "cloud-api-service"
  cluster                           = aws_ecs_cluster.cloud_api.id
  task_definition                   = aws_ecs_task_definition.cloud_api.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "cloud-api"
    container_port   = var.cloud_api_container_port
  }

  tags = {
    Name        = "cloud-api-service"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}
