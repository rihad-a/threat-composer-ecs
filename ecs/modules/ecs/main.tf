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
    "image": "291759414346.dkr.ecr.eu-west-2.amazonaws.com/ecs-project:2e177e79c482bb9c74c2f948301629a1182cfec2",
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
    target_group_arn = var.tg_arn
    container_name   = var.ecs-container-name
    container_port   = var.ecs-containerport
  }

  network_configuration {
   subnets         = [var.subnetpri1_id]
   security_groups = [aws_security_group.sg2.id]
 }
}
 
resource "aws_security_group" "sg2" {
  name = "sg2"
  vpc_id = var.vpc_id

  ingress {
    from_port        = var.ecs-port-2
    to_port          = var.ecs-port-2
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = var.ecs-port-1
    to_port          = var.ecs-port-1
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = var.ecstg-port
    to_port          = var.ecstg-port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
