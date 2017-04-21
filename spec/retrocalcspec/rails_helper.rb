ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  # Allow referencing FactoryGirl methods without needing to
  # prefix them with `FactoryGirl.`
  config.include FactoryGirl::Syntax::Methods

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
end
