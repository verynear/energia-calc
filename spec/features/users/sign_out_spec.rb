require 'rails_helper'

feature 'Sign out', :devise do
  scenario 'user signs out successfully' do
    sign_in
    click_link 'Logout'
    expect(page).to have_content 'Signed out'
  end
end
