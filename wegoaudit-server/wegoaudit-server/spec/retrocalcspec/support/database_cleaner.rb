RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean_with(:transaction)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation,
                               { except: %w[report_templates],
                                 pre_count: true,
                                 reset_ids: false }
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/general_seeds.rb"
  end

  config.before(:each, real_measure: true) do
    load "#{Rails.root}/db/measure_specific_seeds.rb"
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
