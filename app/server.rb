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
  end

  private

  def stats
    client = Sidekiq::Stats.new
    {
      processed: client.processed,
      failed: client.failed,
      scheduled: client.scheduled_size,
      retry: client.retry_size,
      dead: client.dead_size,
      enqueued: client.enqueued,
      processes: client.processes_size,
      workers: client.workers_size,
    }
  end
end
