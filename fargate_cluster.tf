resource "aws_ecs_cluster" "apache-ignite-example-cluster" {
  name = "apache-ignite-example-cluster"
}

resource "aws_ecs_task_definition" "apache-ignite-example-task-definition" {
  family                   = "apache-ignite-example-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  
  container_definitions = jsonencode([{
    name      = "apache-ignite-container"
    image     = "apacheignite/ignite:2.11.0"
    //image     = "public.ecr.aws/amazonlinux/amazonlinux:latest"
    //commad = [""]
    essential = true
    security_groups = [aws_security_group.allow_ignite_ports.id]
            logConfiguration: {
        logDriver: "awslogs",
          options: {
            awslogs-group: "/ecs/ignite-cluster",
            awslogs-region: "eu-west-2",
            awslogs-stream-prefix: "ecs"
          }
        },
    mountPoints: [
        {
          sourceVolume: "ignite-persistant-storage",
          containerPath: "/app/efs"
        }
      ]

    portMappings = [{
      protocol      = "tcp"
      containerPort = 11211
      hostPort      = 11211
      },
      {
        protocol      = "tcp"
        containerPort = 47100
        hostPort      = 47100
      },
      {
        protocol      = "tcp"
        containerPort = 47500
        hostPort      = 47500
      },
      {
        protocol      = "tcp"
        containerPort = 49112
        hostPort      = 49112
      }
  ] }])


  volume {
    name      = "ignite-persistant-storage"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.ignite_persistent_stogare.id
      root_directory          = "/"
    }
  }
}

resource "aws_ecs_service" "apache-ignite-service" {
 name                               = "apache-ignite-service"
 cluster                            = aws_ecs_cluster.apache-ignite-example-cluster.id
 task_definition                    = aws_ecs_task_definition.apache-ignite-example-task-definition.arn
 desired_count                      = 2
 deployment_minimum_healthy_percent = 50
 deployment_maximum_percent         = 200
 launch_type                        = "FARGATE"
 scheduling_strategy                = "REPLICA"
 
 network_configuration {
   security_groups  = [aws_security_group.allow_ignite_ports.id]
   subnets          = module.vpc.private_subnets
   assign_public_ip = false
 }
 
 load_balancer {
   target_group_arn = aws_lb_target_group.ignite-nlb-target-group-11211.arn 
   container_name   = "apache-ignite-container"
   container_port   = 11211
 }
}
resource "aws_cloudwatch_log_group" "ignite-cluster-logs" {
  name = "/ecs/ignite-cluster"
}
