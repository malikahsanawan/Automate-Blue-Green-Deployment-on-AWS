resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

resource "aws_ecr_repository" "main" {
  name = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

resource "aws_ecs_task_definition" "blue" {
  family                = "${var.ecs_cluster_name}-blue"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${aws_ecr_repository.main.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.ecs_cluster_name}-blue"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "green" {
  family                = "${var.ecs_cluster_name}-green"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${aws_ecr_repository.main.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.ecs_cluster_name}-green"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "blue" {
  name            = "${var.ecs_cluster_name}-blue"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.blue.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_blue_arn
    container_name   = "app"
    container_port   = 3000
  }
  depends_on = [aws_ecs_task_definition.blue]
}

resource "aws_ecs_service" "green" {
  name            = "${var.ecs_cluster_name}-green"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.green.arn
  desired_count   = 0
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_green_arn
    container_name   = "app"
    container_port   = 3000
  }
  depends_on = [aws_ecs_task_definition.green]
}

output "ecr_repo_url" {
  value = aws_ecr_repository.main.repository_url
}
output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}
output "ecs_service_blue_name" {
  value = aws_ecs_service.blue.name
}
output "ecs_service_green_name" {
  value = aws_ecs_service.green.name
}
