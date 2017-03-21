require 'support/helpers/omniauth'

RSpec.configure do |config|
  config.include Omniauth::Mock
  config.include Omniauth::SessionHelpers, type: :feature

  config.before(:each) do
    OmniAuth.config.mock_auth[:wegowise] = nil
  end
end

OmniAuth.config.test_mode = true
