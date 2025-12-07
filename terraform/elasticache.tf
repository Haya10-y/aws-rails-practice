resource "aws_elasticache_subnet_group" "valkey" {
  name       = "aws-rails-test-subnet-group-valkey"
  description = " "
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id,
  ]
}

resource "aws_elasticache_replication_group" "valkey" {
  replication_group_id          = "aws-rails-test-valkey-cluster"
  description = " "
  apply_immediately = false
  auto_minor_version_upgrade = "true"
  cluster_mode = "disabled"

  engine         = "valkey"
  engine_version = "7.2"

  node_type = "cache.t4g.micro"

  subnet_group_name  = aws_elasticache_subnet_group.valkey.name
  security_group_ids = [aws_security_group.elasticache.id]

  port = 6379

  at_rest_encryption_enabled   = true
  transit_encryption_enabled   = true

  automatic_failover_enabled = true
  multi_az_enabled           = true

  parameter_group_name = "default.valkey7"

  snapshot_retention_limit = 0
}
