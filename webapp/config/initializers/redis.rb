# Redis configuration
redis_config = {
  host: ENV.fetch('REDIS_HOST', 'redis'),
  port: ENV.fetch('REDIS_PORT', 6379),
  db: ENV.fetch('REDIS_DB', 0),
  password: ENV.fetch('REDIS_PASSWORD', nil)
}

# Initialize Redis connection
$redis = Redis.new(redis_config)

# Optional: Test the connection
begin
  $redis.ping
  Rails.logger.info "Redis connection established successfully"
rescue Redis::CannotConnectError => e
  Rails.logger.warn "Failed to connect to Redis: #{e.message}"
  Rails.logger.warn "Redis functionality may be limited"
rescue => e
  Rails.logger.warn "Redis connection error: #{e.message}"
end
