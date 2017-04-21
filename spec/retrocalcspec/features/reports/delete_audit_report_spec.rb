require 'features_helper'

feature 'user can delete audit report', :js do
  include Features::AuditReportSupport
  include Features::CommonSupport
  include Features::WebSupport

  let!(:user) { create(:user) }

  before do
    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [],
      audit_name: 'Panda Test Audit 1'
    )

    click_link 'RetroCalc'

    set_up_audit_report(
      user: user,
      measure_selections: [],
      audit_name: 'Panda Test Audit 2'
    )

    click_link 'RetroCalc'
    expect(page).to have_content 'View reports'
  end

  let!(:report1) { AuditReport.first }
  let!(:report2) { AuditReport.last }

  scenario 'from report list and individual report' do
    # from reports index
    within row_for(report1) do
      click_link 'Delete report'
      accept_javascript_alert 'Are you sure you want to delete this report?'
    end

    expect(page).to_not have_content report1.name

    # from report show page
    within row_for(report2) do
      click_link 'Edit measures'
    end
    click_link 'Delete report'
    accept_javascript_alert 'Are you sure you want to delete this report?'

    expect(page).to have_content 'View reports'
    expect(page).to_not have_content report2.name
  end

  def row_for(report)
    "tr#audit_report_#{report.id}"
  end
end
