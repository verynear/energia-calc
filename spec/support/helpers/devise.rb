module Devise
  module Mock
    def login_user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryGirl.create(:user)
        sign_in user
      end
    end
  end

  module SessionHelpers
    def signin_as(user)
      visit root_path
      expect(page).to have_content("Login")
      login_user
      click_link "Login"
    end
  end
end
