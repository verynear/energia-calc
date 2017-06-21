require 'features_helper'
require 'pdf-reader'

feature 'Add report template', :js do
  include Features::AuditReportSupport
  include Features::CommonSupport
  include Features::DownloadSupport

  let!(:user) do
    create(:user,
           name: 'Sad Panda',
           phone: '617-555-1234',
           email: 'sadpanda@newecology.org')
  end

  scenario 'select template to display an audit report' do
    sign_in
    set_up_audit_report(
      user: user,
      measure_selections: [],
      audit_name: 'Panda Test Audit'
    )

    click_link 'Manage templates'
    click_new_template_button

    fill_in 'report_template_name', with: 'my template'
    fill_in 'report_template_markdown', with: template_markdown

    within_pdf_preview do
      expect(page).to have_content 'Sad Panda'
    end

    click_button 'Save'
    expect(page).to have_content 'my template'

    # navigate to an audit report, and use this template
    click_link 'All reports'
    click_link 'Edit measures'
    click_link 'Edit PDF report'

    select 'my template', from: 'Select template'
    click_button 'Save'

    fill_in 'content_block[recommendations]', with: 'custom'

    # live preview includes contentblock text
    expect_pdf_preview_to_match(
      'Sad Panda',
      'custom'
    )

    click_button 'Save'
    click_link 'View PDF report'

    # PDF file also includes contentblock text
    expect_pdf_file_download do |pages|
      page = pages.first
      expect(page.text).to include 'Sad Panda'
      expect(page.text).to include 'custom'
    end
  end

  def click_new_template_button
    find('a.js-new-template-button').click
  end

  def template_markdown
    "{{ user_name }}\n\n{% contentblock recommendations %}"
  end
end
