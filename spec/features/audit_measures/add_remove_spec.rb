require 'rails_helper'

feature 'While viewing measures for an audit', :devise, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:measure1) { create(:audit_measure, name: 'DHW, Toilets') }
  let!(:measure2) { create(:audit_measure, name: 'Boiler Controls') }

  before do
    sign_in
    visit audits_path
    click_audit audit.name
    click_section_tab 'Measures'
  end

  scenario 'all measures are listed' do
    expect(page.find(:checkbox, 'DHW, Toilets')).to be_present
    expect(page.find(:checkbox, 'Boiler Controls')).to be_present
  end

  scenario 'measures can be toggled' do
    # A measure can be selected
    check 'Boiler Controls'

    # The measure should still be selected when we navigate back to it.
    click_crumb_link 'All audits'
    click_audit audit.name
    click_section_tab 'Measures'
    expect(page).to have_selected_measure 'Boiler Controls'

    # The measure can be deselected
    uncheck 'Boiler Controls'

    # The measure should NOT be selected when we navigate back to it.
    click_crumb_link 'All audits'
    click_audit audit.name
    click_section_tab 'Measures'
    expect(page).to have_deselected_measure 'Boiler Controls'
  end

  scenario 'measures can have notes' do
    check 'DHW, Toilets'
    fill_in 'DHW, Toilets', with: 'Toilets should not need hot water'

    click_crumb_link 'All audits'
    click_audit audit.name
    click_section_tab 'Measures'
    expect(page).to have_field('DHW, Toilets',
                               with: 'Toilets should not need hot water')
  end
end
