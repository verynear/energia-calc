require 'sidekiq/web'

if Rails.env.production? || Rails.env.staging?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    return false unless ENV['SIDEKIQ_WEB_PASSWORD'] && ENV['SIDEKIQ_WEB_USER']
    username == ENV['SIDEKIQ_WEB_USER'] &&
      password == ENV['SIDEKIQ_WEB_PASSWORD']
  end
end
