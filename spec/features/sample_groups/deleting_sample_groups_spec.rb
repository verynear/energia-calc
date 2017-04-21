require 'rails_helper'

feature 'Deleting sample groups', :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:building_type) do
    create(:building_structure_type,
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:apartment_type) do
    create(:apartment_structure_type,
           parent_structure_type: building_type)
  end
  let!(:common_area_type) do
    create(:common_area_structure_type,
           parent_structure_type: audit.structure.structure_type)
  end

  before do
    signin_as user
    click_audit audit.name
  end

  scenario 'from audits and structures' do
    click_structure_type 'Common Area', action: 'Add Sample Group'
    fill_in 'Name', with: 'My common area'
    fill_in 'Sample size', with: 10
    click_button 'Create'

    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    click_structure_row '201 South Street'

    click_structure_type 'Apartment', action: 'Add Sample Group'
    fill_in 'Name', with: 'My apartment'
    fill_in 'Sample size', with: 10
    click_button 'Create'

    click_structure_row 'My apartment', action: 'Delete'
    click_delete_confirmation 'Cancel'
    click_structure_row 'My apartment', action: 'Delete'
    click_delete_confirmation 'Delete'
    expect(page).to_not have_structure_row('My apartment')

    click_crumb_link audit.name

    click_structure_row 'My common area', action: 'Delete'
    click_delete_confirmation 'Cancel'
    click_structure_row 'My common area', action: 'Delete'
    click_delete_confirmation 'Delete'
    expect(page).to_not have_structure_row('My common area')
  end
end

