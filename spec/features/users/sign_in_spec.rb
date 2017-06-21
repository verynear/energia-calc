require 'rails_helper'

feature 'Sign in', :devise do
  scenario "user can sign in with valid account" do
    sign_in
    expect(page).to have_content("Logout")
  end

  scenario 'user cannot sign in with invalid account' do
    visit root_path
    expect(page).to have_content("Login")
    click_link "Login"
    sign_in nil
    expect(page).to have_content('Authentication error')
  end
end
