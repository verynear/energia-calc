ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'devise'

# ActiveRecord::Migration.maintain_test_schema!

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'paperclip/matchers'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Allow referencing FactoryGirl methods without needing to
  # prefix them with `FactoryGirl.`
  config.include FactoryGirl::Syntax::Methods

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.before(:each) do
    Measure.unmemoize_all
    StructureType.unmemoize_all
    Field.unmemoize_all
    Kilomeasure.reset
    MeasureDefinitionsRegistry.reset_data_path
    MeasureDefinitionsRegistry.reset
  end

  config.before(:each, real_measure: true) do
    Kilomeasure.load
  end

  config.include Paperclip::Shoulda::Matchers

  config.include Helpers::Forms
  config.include Helpers::Html
  config.include Helpers::Navigation


  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
end
