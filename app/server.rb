# frozen_string_literal: true

require "sinatra"
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

  ##################################
  # Return a Hello world JSON
  ##################################
  get "/hello-world" do
    content_type :json
    { Output: "Hello World!" }.to_json
  end
end
