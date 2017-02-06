require 'rails_helper'

feature 'Editing sample group details', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:common_area_type) do
    create(:structure_type,
           name: 'Common Area',
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:hallway_structure) do
    create(:sample_group,
           n_structures: 2,
           name: 'Hallways',
           parent_structure: audit.structure,
           structure_type: common_area_type)
  end

  scenario 'for attributes on the sample group record' do
    signin_as(user)
    click_audit audit.name
    click_structure_row 'Hallways'
    click_section_tab 'Details'
    expect(page).to have_grouping 'Sample Group'
    expect(page).to have_field('Name', with: 'Hallways')
    expect(page).to have_field('Sample Size', with: '2')

    fill_in 'Name', with: 'Downstairs Hallways'
    fill_in 'Sample Size', with: 10

    # Changes should persit when navigating back to the same page
    click_crumb_link 'All audits'
    click_audit audit.name
    click_structure_row 'Hallways'
    click_section_tab 'Details'
    expect(page).to have_field('Name', with: 'Downstairs Hallways')
    expect(page).to have_field('Sample Size', with: '10')

    # Editing is disabled when the audit is locked
    audit.update(locked_by: user.id)
    visit current_path
    click_section_tab 'Details'
    expect(page).to have_field('Name', disabled: true)
    expect(page).to have_field('Sample Size', disabled: true)
  end
end
