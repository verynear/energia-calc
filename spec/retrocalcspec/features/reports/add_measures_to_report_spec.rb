require 'features_helper'

feature 'add measures to report', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport

  let!(:user) { create(:user) }
  let!(:measure1) { create(:measure, name: 'measure1') }
  let!(:measure2) { create(:measure, name: 'measure2') }
  let!(:measure3) { create(:measure, name: 'measure3') }
  let!(:measure4) { create(:measure, name: 'measure4') }

  before do
    Kilomeasure.add_measure('measure1', {})
    Kilomeasure.add_measure('measure2', {})
    Kilomeasure.add_measure('measure4', {})
  end

  scenario 'Adding a measure to a report in progress' do
    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [
        { measure: measure1, notes: 'notes for measure1' },
        { measure: measure4 }
      ],
      audit_name: '123 Main St'
    )

    expect_measure_tabs(measure1.name, measure4.name)
    expect_active_measure(measure1, notes: 'notes for measure1')

    # add a new measure
    click_link 'Add measure'
    should_see_modal('Add a new measure to this report') do
      expect_measure_options(measure1.name, measure2.name, measure4.name)
      select 'measure2', from: 'measure_selection[measure_id]'
      click_button 'Add measure'
    end

    expect_measure_tabs(measure1.name, measure4.name, measure2.name)
    expect_active_measure(measure2)

    # add another version of a measure that is already present
    click_link 'Add measure'
    should_see_modal('Add a new measure to this report') do
      select 'measure1', from: 'measure_selection[measure_id]'
      click_button 'Add measure'
    end

    expect_measure_tabs(measure1.name, measure4.name, measure2.name, measure1.name)
    expect_active_measure(measure1)
  end
end
