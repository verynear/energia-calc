source 'https://rubygems.org'

# gem 'aws-sdk'
gem 'activerecord-import'
gem 'autoprefixer-rails'
gem 'coffee-rails'
gem 'delayed_paperclip'
gem 'devise', '~> 4.2'
# gem 'door_stop', path: 'vendor/gems/door_stop'
gem 'faraday'
gem 'faraday_middleware-parse_oj'
gem 'foreigner'
gem 'ice_nine'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'json-schema'
gem 'memoizer'
gem 'oauth'
gem 'oj'
gem 'oj_mimic_json'
gem 'omniauth'
gem 'paperclip'
gem 'pg'
gem 'puma'
gem 'rails', '4.2.1'
gem 'ranked-model'
gem 'redcarpet'
gem 'rubyzip'
gem 'sass-rails'
# gem 'sidekiq', '~> 3.4.0'
gem 'sinatra', '>= 1.3.0', require: false
gem 'uglifier'
gem 'whenever', require: false
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'   # needed for wicked-pdf
gem 'kilomeasure', path: 'vendor/gems/kilomeasure'
gem 'liquid'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'guard-rails'
  gem 'guard-rubocop'
  gem 'overcommit'
  gem 'quiet_assets'
  gem 'rails-erd'
  gem 'spring', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'wkhtmltopdf-binary-edge'
end

group :test do
  gem 'capybara'
  gem 'curb'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'pdf-reader'
  gem 'rubocop', require: false
  gem 'webmock'
end

group :staging, :production do
  gem 'lograge'
  gem 'rails_12factor'
  gem 'wkhtmltopdf-heroku'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-backbone', '>= 1.2.3'
  gem 'rails-assets-backbone-relational', '>= 0.10.0'
end