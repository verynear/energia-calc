module Omniauth
  module Mock
    def auth_mock(user)
      OmniAuth.config.mock_auth[:wegowise] = OmniAuth::AuthHash.new(
        provider: 'wegowise',
        uid: user.wegowise_id,
        info: { username: user.username },
        credentials: {
          token: 'mock_token',
          secret: 'mock_secret'
        },
        extra: {
          access_token: double(token: 'mock_token', secret: 'mock_secret')
        }
      )
    end
  end

  module SessionHelpers
    def signin_as(user)
      client = instance_double(WegowiseClient)
      allow(WegowiseClient).to receive(:new).and_return(client)

      if user.organization_id
        allow(client).to receive(:organizations)
          .and_return [{ 'id' => user.organization.wegowise_id,
                         'name' => user.organization.name }]
      else
        allow(client).to receive(:organizations)
          .and_return [{ 'id' => 3, 'name' => 'pandas' }]
      end

      visit root_path
      auth_mock(user)
      click_link 'Login'
    end
  end
end
