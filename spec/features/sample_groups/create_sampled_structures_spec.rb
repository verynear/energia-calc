require 'rails_helper'

feature 'Creating sampled structures within a sample group', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let(:audit_structure_type) { audit.audit_structure.audit_structure_type }
  let!(:common_area_type) do
    create(:common_area_audit_strc_type,
           parent_structure_type: audit_structure_type)
  end
  let!(:hallways_sample_group) do
    create(:sample_group,
           n_structures: 1,
           name: 'Downstairs hallways',
           parent_structure: audit.audit_structure,
           audit_strc_type: common_area_type)
  end

  before do
    signin_as user
    click_audit audit.name
  end

  scenario 'when the sample group is not full' do
    click_structure_row 'Downstairs hallways'
    click_link 'Add Sample'
    fill_in 'Name', with: 'Fronts'
    click_button 'Create'

    expect(page).to have_link('Fronts')
    expect(page).to_not have_link('Add Sample')
  end

  scenario 'is unavailable when an audit is locked' do
    audit.update(locked_by: user.id)
    click_structure_row 'Downstairs hallways'
    expect(page).to_not have_link 'Add Sample'
  end
end
