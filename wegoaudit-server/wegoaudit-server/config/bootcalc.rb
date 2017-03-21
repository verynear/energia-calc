ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

module DefaultServerPort
  def default_options
    super.merge!(Port: 3000)
  end
end

require 'rails/commands/server'

module Rails
  class Server
    prepend DefaultServerPort
  end
end
