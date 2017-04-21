require 'rails_helper'

feature 'Linking structures to physical structures', :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let!(:organization) do
    create(:organization,
           owner: user)
  end
  let!(:building_type) do
    create(:building_structure_type,
           parent_structure_type: audit.structure.structure_type)
  end
  let!(:building) do
    create(:building,
           cloned: false,
           nickname: '201 South Street',
           wegowise_id: 42)
  end

  before do
    organization.buildings << building
    organization.save!

    signin_as(user)
    visit audits_path
    click_audit audit.name
  end

  scenario 'with an existing building' do
    click_structure_type 'Building', action: 'Add'
    fill_in 'Name', with: 'My temporary building'
    click_button 'Create'

    click_structure_row 'My temporary building', action: 'Link'
    search_for 'foo'
    expect(page).to have_content 'No buildings found that match "foo".'

    search_for 'south'
    expect(page).to have_unchecked_field '201 South Street'

    choose '201 South Street'
    click_button 'Link'

    expect(page).to have_structure_row '201 South Street'
  end

  scenario 'is unavailable when the audit is locked' do
    audit.update(locked_by: user.id)
    visit current_path
    expect(page).to_not have_structure_action 'Link'
  end

  def search_for(query)
    fill_in 'q', with: query
    find(:css, 'button.js-submit-search').click
  end
end
