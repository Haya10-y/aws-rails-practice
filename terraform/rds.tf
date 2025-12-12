resource "aws_db_subnet_group" "rails-test" {
  name       = "default-vpc-00204fb854441d3f4"
  description= "DB subnet group for Rails test application"
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
    aws_subnet.private_a.id,
    aws_subnet.private_c.id,
  ]
}

resource "aws_db_instance" "rails-test" {
  identifier = "aws-rails-test-rds"

  engine            = "mysql"
  engine_version    = "8.4.7"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  max_allocated_storage = 1000
  apply_immediately = false

  username = "admin"

  db_subnet_group_name = aws_db_subnet_group.rails-test.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  multi_az = true

  parameter_group_name = "default.mysql8.4"
  option_group_name    = "default:mysql-8-4"

  backup_retention_period = 0 # 本番環境では 7 などの値にすること
  copy_tags_to_snapshot = true

  auto_minor_version_upgrade = true

  performance_insights_enabled = false

  monitoring_interval = 0

  storage_encrypted = true

  deletion_protection = false

  skip_final_snapshot = true
}
