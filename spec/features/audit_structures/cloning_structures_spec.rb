require 'rails_helper'

feature 'Cloning structures', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:heating_system_type) do
    create(:audit_strc_type,
           name: 'Heating System',
           parent_structure_type: audit.audit_structure.audit_strc_type)
  end
  let!(:existing_structure) do
    create(:audit_structure,
           name: 'My existing structure',
           audit_strc_type: heating_system_type,
           parent_structure: audit.audit_structure)
  end

  before do
    signin_as(user)
    visit audits_path
    click_audit audit.name
  end

  scenario 'once, with a single name' do
    click_structure_row 'My existing structure', action: 'Clone'
    fill_in 'Number of copies', with: 1
    fill_in 'Name Pattern', with: 'My new structure'
    click_button 'Create'

    expect(page).to have_structure_row 'My new structure'
  end

  scenario 'with a letter wildcard' do
    click_structure_row 'My existing structure', action: 'Clone'
    fill_in 'Number of copies', with: 2
    fill_in 'Name Pattern', with: 'My new structure ?'
    click_button 'Create'

    expect(page).to have_structure_row 'My new structure A'
    expect(page).to have_structure_row 'My new structure B'
  end

  scenario 'with a numerical wildcard' do
    click_structure_row 'My existing structure', action: 'Clone'
    fill_in 'Number of copies', with: 2
    fill_in 'Name Pattern', with: 'My new structure #'
    click_button 'Create'

    expect(page).to have_structure_row 'My new structure 1'
    expect(page).to have_structure_row 'My new structure 2'
  end

  scenario 'is unavailable when the audit is locked' do
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to_not have_structure_action 'Clone'
  end
end
