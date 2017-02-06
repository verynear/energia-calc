require 'rails_helper'

feature 'Sign in', :omniauth do
  scenario "user can sign in with valid account" do
    user = create(:user)
    signin_as(user)
    expect(page).to have_content("Logout")
  end

  scenario 'user cannot sign in with invalid account' do
    OmniAuth.config.mock_auth[:wegowise] = :invalid_credentials
    visit root_path
    expect(page).to have_content("Login")
    click_link "Login"
    expect(page).to have_content('Authentication error')
  end
end
