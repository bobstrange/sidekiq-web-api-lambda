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
      get "/:name/count" do |name|
        content_type :json

        { count: queue_client(name).size }.to_json
      end

      get "/:name/jobs" do |name|
        content_type :json

        { jobs: jobs(name) }.to_json
      end
    end
  end

  private

  def stats_client
    Sidekiq::Stats.new
  end

  def queue_client(queue_name = "default")
    Sidekiq::Queue.new(queue_name)
  end

  def stats
    stats_client = Sidekiq::Stats.new
    stats_client.fetch_stats!
  end

  def queues
    stats_client.queues
  end

  def jobs(queue_name)
    client = queue_client(queue_name)
    jobs = []
    client.each { |job| jobs << job }
    jobs
  end
end
