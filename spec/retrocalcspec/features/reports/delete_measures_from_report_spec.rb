require 'features_helper'

feature 'delete measures from audit report', :js do
  include Features::AuditReportSupport
  include Features::CommonSupport
  include Features::WebSupport

  let!(:user) { create(:user) }
  let!(:measure1) { create(:measure, name: 'measure1') }
  let!(:measure2) { create(:measure, name: 'measure2') }
  let!(:measure3) { create(:measure, name: 'measure3') }

  scenario 'when viewing measures manager' do
    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [
        { measure: measure1 },
        { measure: measure2 },
        { measure: measure3 }
      ],
      audit_name: '123 Main St'
    )

    expect_measure_tabs(measure1.name, measure2.name, measure3.name)

    # delete measure1, then measure2 is active
    within_active_measure do
      click_delete_measure_button_and_confirm
    end
    expect_selected_measure_tab(measure2.name)
    expect_measure_tabs(measure2.name, measure3.name)

    # select measure3, then delete it
    click_link measure3.name
    expect_selected_measure_tab(measure3.name)
    within_active_measure do
      click_delete_measure_button_and_confirm
    end
    expect_selected_measure_tab(measure2.name)
    expect_measure_tabs(measure2.name)
  end
end
