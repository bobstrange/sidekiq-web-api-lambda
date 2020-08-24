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

  namespace "/api/sidekiq/stats" do
    get "/processed" do
      content_type :json

      { data: Sidekiq::Stats.new.processed }.to_json
    end
  end
end
