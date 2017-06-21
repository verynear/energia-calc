require 'rails_helper'

feature 'Creating structures', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let(:audit_audit_strc_type) { audit.audit_structure.audit_strc_type }
  let!(:building_type) do
    create(:building_audit_strc_type,
           parent_structure_type: audit_audit_strc_type)
  end
  let!(:heating_system_type) do
    create(:audit_strc_type,
           name: 'Heating System',
           parent_structure_type: audit_audit_strc_type,
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
    controls_type = create(:audit_strc_type,
                           name: 'Controls',
                           parent_structure_type: heating_system_type,
                           primary: true)
    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    audit_structure = AuditStructure.find_by(name: '201 South Street')
    expect(audit_structure.audit_strc_type).to eq controls_type
  end

  scenario 'with a structure subtype selected' do
    heating_system_type.update(primary: false)
    controls_type = create(:audit_strc_type,
                           name: 'Controls',
                           parent_structure_type: heating_system_type,
                           primary: true)
    outdoor_cutoff_type = create(:audit_strc_type,
                                 name: 'Outdoor Cutoff',
                                 parent_structure_type: controls_type,
                                 primary: true)
    click_structure_type 'Heating System', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'
    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    audit_structure = AuditStructure.find_by(name: '201 South Street')
    expect(audit_structure.audit_strc_type).to eq outdoor_cutoff_type
  end

  scenario 'with an associated physical structure' do
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: '201 South Street'
    click_button 'Create'

    expect(page).to have_structure_row('201 South Street')

    # Check the database record, because we need to confirm that the _exact_
    # structure type has been set correctly.
    audit_structure = AuditStructure.find_by(name: '201 South Street')
    expect(audit_structure.audit_strc_type).to eq building_type
    expect(audit_structure.physical_structure).to_not be_nil
    expect(audit_structure.physical_structure.name).to eq audit_structure.name
  end

  scenario 'as substructures of structures' do
    exterior_type = create(:audit_strc_type,
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
