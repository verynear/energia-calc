ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'paperclip/matchers'
require 'sidekiq/testing'

Sidekiq::Testing.fake!
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers

  config.include Helpers::Forms
  config.include Helpers::Html
  config.include Helpers::Navigation

  config.before(:each) do |example|
    Sidekiq::Worker.clear_all
  end

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
end
