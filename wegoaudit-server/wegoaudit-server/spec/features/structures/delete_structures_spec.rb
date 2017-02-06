require 'rails_helper'

feature 'Deleting structures', :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:building_type) do
    create(:building_structure_type,
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:heating_system_type) do
    create(:structure_type,
           name: 'Heating System',
           parent_structure_type: building_type,
           primary: true)
  end

  before do
    signin_as user
    click_audit audit.name
  end

  scenario 'from audits and structures' do
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    click_structure_row '201 South Street'

    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: 'Heater'
    click_button 'Create'

    click_structure_row 'Heater', action: 'Delete'
    click_delete_confirmation 'Cancel'
    click_structure_row 'Heater', action: 'Delete'
    click_delete_confirmation 'Delete'
    expect(page).to_not have_structure_row('Heater')

    click_crumb_link audit.name
    click_structure_row '201 South Street', action: 'Delete'
    click_delete_confirmation 'Cancel'
    click_structure_row '201 South Street', action: 'Delete'
    click_delete_confirmation 'Delete'
    expect(page).to_not have_structure_row('201 South Street')
  end
end
