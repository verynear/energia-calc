require 'features_helper'

feature 'Organization access', :js do
  include Features::CommonSupport

  let!(:org1) { create(:organization, name: 'boston pandas') }
  let!(:org2) { create(:organization, name: 'other pandas') }

  let!(:user1) { create(:user, organization: org1) }
  let!(:user2) { create(:user, organization: org1) }
  let!(:user3) { create(:user, organization: org2) }

  scenario 'access audit reports and templates belonging to org' do
    # create audit report and template
    signin_as(user1)
    set_up_audit_report(
      user: user1,
      measure_selections: [],
      audit_name: 'Panda Test Audit'
    )

    click_link 'Manage templates'
    click_new_template_button

    fill_in 'report_template_name', with: 'my template'
    fill_in 'report_template_markdown', with: 'template text'
    click_button 'Save'
    click_link 'Logout'

    # user in same org can access report and template
    signin_as(user2)
    click_link 'All reports'
    expect(page).to have_content 'Panda Test Audit'

    click_link 'Edit measures'
    click_link 'Edit PDF report'
    select 'my template', from: 'Select template'
    click_button 'Save'
    click_link 'Logout'

    # user in other org cannot access report or template
    signin_as(user3)
    click_link 'All reports'
    expect(page).to_not have_content 'Panda Test Audit'

    click_link 'Manage templates'
    expect(page).to_not have_content 'my template'
  end

  def click_new_template_button
    find('a.js-new-template-button').click
  end
end
