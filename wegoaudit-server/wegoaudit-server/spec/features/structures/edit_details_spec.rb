require 'rails_helper'

feature 'Structure details', :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:heating_system_type) do
    create(:structure_type,
           name: 'Heating System',
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:structure) do
    create(:structure,
           name: 'Basement furnace',
           parent_structure: audit.structure,
           structure_type: heating_system_type)
  end

  before do
    signin_as(user)
    click_audit audit.name
  end

  scenario 'for attributes on a structure record' do
    click_structure_row 'Basement furnace'
    click_section_tab 'Details'
    expect(page).to have_grouping 'Structure'
    expect(page).to have_field('Name', with: 'Basement furnace')

    fill_in 'Name', with: 'New basement furnace'

    # Changes should persist when navigating back to the same page
    click_crumb_link 'All audits'
    click_audit audit.name
    click_structure_row 'New basement furnace'
    click_section_tab 'Details'
    expect(page).to have_field('Name', with: 'New basement furnace')

    # Editing is disabled when the audit is locked
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to have_field('Name', disabled: true)
  end

  scenario 'for structure fields' do
    grouping = create(:grouping,
                      name: 'General',
                      structure_type: structure.structure_type)
    create(:field, :decimal,
           display_order: 1,
           grouping: grouping,
           name: 'Steam Pressure')
    create(:field, :switch,
           display_order: 2,
           grouping: grouping,
           name: 'Does it work?')
    create(:field, :text,
           display_order: 3,
           grouping: grouping,
           name: 'Notes')

    click_audit audit.name
    click_structure_row 'Basement furnace'
    click_section_tab 'Details'
    expect(page).to have_grouping 'General'
    expect(page).to have_field('Steam Pressure')
    expect(page).to have_unchecked_field('Does it work?')
    expect(page).to have_field('Notes')

    fill_in 'Steam Pressure', with: 1.21
    check 'Does it work?'
    fill_in 'Notes', with: 'No comment'
    click_crumb_link 'All audits'

    click_audit audit.name
    click_structure_row 'Basement furnace'
    click_section_tab 'Details'
    expect(page).to have_field('Steam Pressure', with: '1.21')
    expect(page).to have_checked_field('Does it work?')
    expect(page).to have_field('Notes', with: 'No comment')

    # Editing is disabled when the audit is locked
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to have_field('Steam Pressure', disabled: true)
    expect(page).to have_field('Does it work?', disabled: true)
    expect(page).to have_field('Notes', disabled: true)
  end
end
