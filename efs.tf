resource "aws_efs_file_system" "ignite_persistent_stogare" {
  encrypted              = false
  performance_mode       = "generalPurpose"
  throughput_mode        = "bursting"
  creation_token         = "ecs-efs-ignite"
}

resource "aws_efs_mount_target" "ecs_mount_target_subnet_1" {
  file_system_id = aws_efs_file_system.ignite_persistent_stogare.id
  subnet_id      = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.efs_mount_sg.id]
}

resource "aws_efs_mount_target" "ecs_mount_target_subnet_2" {
  file_system_id = aws_efs_file_system.ignite_persistent_stogare.id
  subnet_id      = module.vpc.private_subnets[1]
  security_groups = [aws_security_group.efs_mount_sg.id]
}

resource "aws_efs_mount_target" "ecs_mount_target_subnet_3" {
  file_system_id = aws_efs_file_system.ignite_persistent_stogare.id
  subnet_id      = module.vpc.private_subnets[2]
  security_groups = [aws_security_group.efs_mount_sg.id]
}

resource "aws_security_group" "efs_mount_sg" {
  name        = "efs_mount_sg"
  description = "efs_mount_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "ECS container to NFS port"
      security_groups = [aws_security_group.allow_ignite_ports.id]
 }

egress {
  description = "Egress allow all"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

}