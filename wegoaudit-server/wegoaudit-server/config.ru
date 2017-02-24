# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

class RetrocalcAuthenticator < DoorStop::Authenticator
  def call(env)
  	if env["PATH_INFO"] =~ %r{\A/retrocalc}
      super
  	else
      @app.call(env)
    end
   end
end

if %w[development test].include?(ENV['RAILS_ENV'])
  ENV['DOORSTOP_SHARED_SECRET'] ||= 's3kr3t'
end

use RetrocalcAuthenticator, ENV['DOORSTOP_SHARED_SECRET']

run Rails.application
