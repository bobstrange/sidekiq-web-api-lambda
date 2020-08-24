# frozen_string_literal: true

require "rack"
require "rack/contrib"
require "sidekiq"

redis_host = ENV["REDIS_HOST"] || "localhost"
redis_port = ENV["REDIS_PORT"] || 6379
redis_db = ENV["REDIS_DB"] || 0

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_host}:#{redis_port}/#{redis_db}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_host}:#{redis_port}/#{redis_db}" }
end

require "sidekiq/web"

require_relative "./app/server"

set(:root, File.dirname(__FILE__))

run Rack::URLMap.new("/" => Server, "/sidekiq" => Sidekiq::Web)
