require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# Dotenv::Railtie.load if defined?(Dotenv)

require File.expand_path('../../lib/constants', __FILE__)

module Wegosurvey
  class Application < Rails::Application

    config.autoload_paths += %W[
      #{config.root}/app/controllers/concerns
      #{config.root}/app/models/concerns
      #{config.root}/lib
      #{config.root}/lib/constants
      #{config.root}/app/servicers
      #{config.root}/app/contexts
      #{config.root}/app/presenters
      #{config.root}/app/presenters/serializers
    ]


    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.paperclip_defaults = {
      storage: :filesystem,
    }

    config.after_initialize do
      require Rails.root.join('lib', 'ext', 'active_record')
    end
    
    config.active_record.raise_in_transactional_callbacks = true
  


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

Rails.logger = Logger.new(STDOUT)