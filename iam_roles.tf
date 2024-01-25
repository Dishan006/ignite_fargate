resource "aws_iam_role" "ecs_task_role" {
  name = "apache-ignite-example-ecsTaskRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_policy" "efs" {
  name        = "apache-ignite-example-task-policy-efs"
  description = "Policy that allows access to EFS"
 
 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
                "elasticfilesystem:CreateMountTarget",
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:CreateFileSystem"
           ],
           "Resource": "*"
       },
       {
           "Effect": "Allow",
           "Action": "s3:*",
           "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket.bucket}"]
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.efs.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "apache-ignite-example-ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}