# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "mqtt"
gem "mqtt_service"
gem "statsd-instrument"
gem "zeitwerk"

group :development do
  gem "rerun"
end

group :test do
	gem "fuubar"
	gem "rspec"
end

group :development, :test do
  gem "pry-byebug"
end
