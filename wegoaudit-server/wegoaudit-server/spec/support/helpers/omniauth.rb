module Omniauth
  module Mock
    def auth_mock(user)
      OmniAuth.config.mock_auth[:wegowise] = OmniAuth::AuthHash.new(
        'provider' => 'wegowise',
        'uid' => user.wegowise_id,
        'user_info' => {'username' => user.username },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        },
        'extra' => double(access_token: double(token: 'mock_secret',
                                        secret: 'mock_secret'))
      )
    end
  end

  module SessionHelpers
    def signin_as(user)
      visit root_path
      expect(page).to have_content("Login")
      auth_mock(user)
      click_link "Login"
    end
  end
end
