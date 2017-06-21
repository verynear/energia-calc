require 'rails_helper'

feature 'Sign in', :devise do
  scenario "user can sign in with valid account" do
    login_user
    expect(page).to have_content("Logout")
  end

  scenario 'user cannot sign in with invalid account' do
    visit root_path
    expect(page).to have_content("Login")
    click_link "Login"
    expect(page).to have_content('Authentication error')
  end
end
