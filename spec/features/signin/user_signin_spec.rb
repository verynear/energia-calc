require 'features_helper'

feature 'user signs in and signs out', :js do
  scenario 'with valid account' do
    sign_in
    expect(page).to have_content 'You have signed in.'
    expect(page).to have_content 'View reports'

    click_link 'Logout'

    expect(page).to have_content 'You have signed out.'
    expect(page).to have_content 'Login'
  end

  scenario 'with invalid account' do
    sign_in nil
    visit root_path
    click_link 'Login'
    expect(page).to have_content 'Authentication error'
  end

  scenario 'cannot visit reports index if not signed in' do
    visit calc_audit_reports_path
    expect(page).to have_content 'You are not allowed to view this page.'
    expect(page).to have_content 'Login'
    expect(page).to have_content 'Welcome to Retrocalc!'
  end
end
