require 'rails_helper'

feature 'Sign out', :omniauth do
  scenario 'user signs out successfully' do
    user = create(:user)
    signin_as(user)
    click_link 'Logout'
    expect(page).to have_content 'Signed out'
  end
end
