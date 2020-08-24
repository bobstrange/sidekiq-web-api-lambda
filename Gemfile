# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "json"
gem "rack"
gem "rack-contrib"
gem "rake"
gem "rubysl-base64"
gem "sidekiq"
gem "sinatra"
gem "sinatra-contrib"

group :test do
  gem "rack-test"
  gem "rspec"
end

group :development do
  gem "ordinare"
  gem "rubocop"
  gem "rubocop-config-rufo", github: "xinminlabs/rubocop-config-rufo", branch: "master"
  gem "rufo"
end
