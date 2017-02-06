require 'rails_helper'

feature 'Creating structures', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let(:audit_structure_type) { audit.structure.structure_type }
  let!(:building_type) do
    create(:building_structure_type,
           parent_structure_type: audit_structure_type)
  end
  let!(:heating_system_type) do
    create(:structure_type,
           name: 'Heating System',
           parent_structure_type: audit_structure_type,
           primary: true)
  end

  before do
    signin_as user
    click_audit audit.name
  end

  scenario 'with defaults' do
    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    expect(page).to have_structure_row('201 South Street')
  end

  scenario 'with a structure type selected' do
    heating_system_type.update(primary: false)
    controls_type = create(:structure_type,
                           name: 'Controls',
                           parent_structure_type: heating_system_type,
                           primary: true)
    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    structure = Structure.find_by(name: '201 South Street')
    expect(structure.structure_type).to eq controls_type
  end

  scenario 'with a structure subtype selected' do
    heating_system_type.update(primary: false)
    controls_type = create(:structure_type,
                           name: 'Controls',
                           parent_structure_type: heating_system_type,
                           primary: true)
    outdoor_cutoff_type = create(:structure_type,
                                 name: 'Outdoor Cutoff',
                                 parent_structure_type: controls_type,
                                 primary: true)
    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    structure = Structure.find_by(name: '201 South Street')
    expect(structure.structure_type).to eq outdoor_cutoff_type
  end

  scenario 'with an associated physical structure' do
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'

    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    structure = Structure.find_by(name: '201 South Street')
    expect(structure.structure_type).to eq building_type
    expect(structure.physical_structure).to_not be_nil
    expect(structure.physical_structure.name).to eq structure.name
  end

  scenario 'as substructures of structures' do
    exterior_type = create(:structure_type,
                           name: 'Exterior',
                           parent_structure_type: building_type,
                           primary: true)
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'

    click_structure_row '201 South Street'
    click_structure_type 'Exterior', action: 'Add'
    fill_in 'Name', with: 'Foo exterior'
    click_button 'Create'

    expect(page).to have_link('Foo exterior')
  end

  scenario 'is unavailable when the audit is locked' do
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to_not have_structure_type_action 'Add'
  end
end
