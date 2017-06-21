require 'rails_helper'

feature 'Editing audit details', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, name: 'My audit', user: user) }
  let!(:audit_structure_type) { audit.audit_structure.audit_strc_type }

  before do
    signin_as user
    visit audits_path
  end

  scenario 'for attributes on the audit structure record' do
    click_audit audit.name
    click_section_tab 'Details'
    expect(page).to have_grouping 'Structure'
    expect(page).to have_field('Name', with: 'My audit')
    fill_in 'Name', with: 'My new audit'
    click_section_tab 'Substructures'

    # Changes should persist when navigating back to the same page
    click_crumb_link 'All audits'
    click_audit 'My new audit'
    click_section_tab 'Details'
    expect(page).to have_field('Name', with: 'My new audit')
  end

  scenario 'for structure fields' do
    grouping = create(:grouping,
                      name: 'Auditor',
                      audit_strc_type: audit.audit_structure.audit_strc_type)
    create(:audit_field, :string,
           display_order: 1,
           grouping: grouping,
           name: 'Auditor name')
    create(:audit_field, :email,
           display_order: 2,
           grouping: grouping,
           name: 'Email')

    click_audit audit.name
    click_section_tab 'Details'
    expect(page).to have_grouping 'Auditor'
    expect(page).to have_field('Auditor name')
    expect(page).to have_field('Email')

    fill_in 'Auditor name', with: 'Marty McFly'
    fill_in 'Email', with: 'mmcfly@wegowise.com'

    click_section_tab 'Substructures'
    click_crumb_link 'All audits'
    click_audit audit.name
    click_section_tab 'Details'
    expect(page).to have_field('Auditor name', with: 'Marty McFly')
    expect(page).to have_field('Email', with: 'mmcfly@wegowise.com')
  end
end
