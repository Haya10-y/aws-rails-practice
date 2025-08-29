# Configure session store to use Redis with cache store
Rails.application.config.session_store :cache_store,
  expire_after: 1.week,
  key: '_webapp_session'
