require 'features_helper'

feature 'visit my account page', :js do
  include Features::MessageSupport

  let!(:user) { create(:user) }
  let!(:old_info) do
    { name: 'Sad Panda',
      email: 'sadpanda@newecology.org',
      phone: '(617) 555-1234' }
  end
  let!(:invalid_email) { 'sadpanda@newecology' }
  let!(:new_phone) { '617-555-1234' }

  scenario 'add and edit contact information' do
    sign_in
    click_link 'My account'

    fill_in 'user_name', with: old_info[:name]
    fill_in 'user_email', with: old_info[:email]
    fill_in 'user_phone', with: old_info[:phone]
    click_button 'Save Contact Details'

    expect_alert_notice 'Your account was successfully updated.'
    expect_contact_fields(*old_info.values)

    fill_in 'user_email', with: invalid_email
    click_button 'Save Contact Details'
    expect_alert_notice 'Sorry, there was an error. Did you enter a valid email?'

    fill_in 'user_phone', with: new_phone
    click_button 'Save Contact Details'

    expect_alert_notice 'Your account was successfully updated.'
    expect_contact_fields(old_info[:name], old_info[:email], new_phone)
  end

  def expect_contact_fields(name, email, phone)
    expect(page).to have_field 'user_name', with: name
    expect(page).to have_field 'user_email', with: email
    expect(page).to have_field 'user_phone', with: phone
  end
end
