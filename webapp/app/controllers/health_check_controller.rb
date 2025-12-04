# frozen_string_literal: true

# MEMO: 最も軽量にするべく、あえて ApplicationController を継承しない。

# rubocop:disable Rails/ApplicationController
class HealthCheckController < ActionController::Base
  def index
    render plain: 'OK', status: :ok
  rescue StandardError => e
    Rails.logger.error("Health check failed: #{e.message}")
    render plain: 'ERROR', status: :service_unavailable
  end
end

# rubocop:enable Rails/ApplicationController
