require 'rails_helper'

feature 'Cloning sampled structures', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:common_area_type) do
    create(:structure_type,
           name: 'Common Area',
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:sample_group) do
    create(:sample_group,
           name: 'Hallways',
           parent_structure: audit.structure,
           structure_type: common_area_type)
  end
  let!(:existing_structure) do
    create(:structure,
           name: 'My existing structure',
           structure_type: common_area_type,
           sample_group: sample_group)
  end

  before do
    signin_as(user)
    visit audits_path
    click_audit audit.name
    click_structure_row 'Hallways'
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

  scenario 'is unavailable when an audit is locked' do
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to_not have_structure_action 'Clone'
  end
end
