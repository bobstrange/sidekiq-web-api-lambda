# frozen_string_literal: true

require "sinatra"
require "sinatra/namespace"
require "sidekiq/api"

# Application class
class Server < Sinatra::Application
  before do
    if !request.body.read.empty? && request.body.size.positive?
      request.body.rewind
      @params = Sinatra::IndifferentHash.new
      @params.merge!(JSON.parse(request.body.read))
    end
  end

  namespace "/api/sidekiq" do
    get "/stats" do
      content_type :json

      stats.to_json
    end

    get "/queues" do
      content_type :json

      queues.to_json
    end

    namespace "/queues" do
      get "/foo" do
        content_type :json

      end

    end
  end

  private

  def stats_client
    Sidekiq::Stats.new
  end

  def stats
    stats_client = Sidekiq::Stats.new
    {
      processed: stats_client.processed,
      failed: stats_client.failed,
      scheduled: stats_client.scheduled_size,
      retry: stats_client.retry_size,
      dead: stats_client.dead_size,
      enqueued: stats_client.enqueued,
      processes: stats_client.processes_size,
      workers: stats_client.workers_size,
    }
  end

  def queues
    stats_client.queues
  end
end
