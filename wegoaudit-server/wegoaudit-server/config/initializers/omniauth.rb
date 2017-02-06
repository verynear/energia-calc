Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wegowise,
           Rails.application.secrets.omniauth_provider_key,
           Rails.application.secrets.omniauth_provider_secret,
           client_options: {
             site: Rails.application.secrets.wegowise_url }
end

OmniAuth.config.logger = Rails.logger
