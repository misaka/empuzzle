# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.0.7"

gem "bootsnap", require: false
gem "cssbundling-rails"
# gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.5"
gem "propshaft"
gem "puma", "~> 6.3"
gem "redis", "~> 4.0"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "view_component"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem "rubocop"
  gem "rubocop-govuk", require: false
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
