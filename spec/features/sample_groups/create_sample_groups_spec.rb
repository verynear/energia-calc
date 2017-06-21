require 'rails_helper'

feature 'Creating sample groups', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let(:audit_structure_type) { audit.audit_structure.audit_strc_type }

  before { sign_in }

  scenario 'with an audit parent structure' do
    common_area_type = create(:common_area_structure_type,
                              parent_structure_type: audit_structure_type)

    click_audit audit.name
    click_structure_type 'Common Area', action: 'Add Sample Group'
    fill_in 'Name', with: 'Downstairs hallways'
    fill_in 'Sample size', with: 2
    click_button 'Create'

    expect(page).to have_link('Downstairs hallways (0 of 2)')
  end

  scenario 'with a structure parent structure' do
    building_type = create(:building_audit_strc_type,
                           parent_structure_type: audit_structure_type)
    apartment_type = create(:apartment_audit_strc_type,
                            parent_structure_type: building_type)

    click_audit audit.name
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'

    click_structure_row '201 South Street'
    click_structure_type 'Apartment', action: 'Add Sample Group'
    fill_in 'Name', with: '6B'
    fill_in 'Sample size', with: 10
    click_button 'Create'

    expect(page).to have_link('6B (0 of 10)')
  end

  scenario 'is unavailable when an audit is locked' do
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to_not have_structure_type_action 'Clone'
  end
end
