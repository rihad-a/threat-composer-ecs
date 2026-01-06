resource "aws_ecs_cluster" "ecs-project" {
  name = "ecs-project"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ecs-docker" {
  family                   = "ecs-docker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "threat-composer",
    "image": "291759414346.dkr.ecr.eu-west-2.amazonaws.com/ecs-project:${{ github.sha }}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],     
      "memory": 2048,
      "cpu": 1024
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "ecs-project" {
  name            = "ecs-project"
  cluster         = aws_ecs_cluster.ecs-project.id
  task_definition = aws_ecs_task_definition.ecs-docker.arn
  desired_count   = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    container_name   = var.ecs-container-name
    container_port   = var.ecs-containerport
  }

  network_configuration {
   subnets         = [aws_subnet.private_1.id]
   security_groups = [aws_security_group.sg.id]
 }
}
 


