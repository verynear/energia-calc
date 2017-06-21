require 'rails_helper'

feature 'Managing structure images', :js do
  let!(:user) { create(:user) }
  let!(:audit) { create(:audit, user: user) }
  let(:test_image_path) do
    Rails.root.join('spec', 'fixtures', 'testupload.jpg')
  end

  before do
    signin_as user
    click_audit audit.name
  end

  scenario 'for an audit structure' do
    click_section_tab 'Photos'
    expect(page).to_not have_css('.thumb img')
    upload_photo test_image_path
    click_section_tab 'Photos'
    expect(page).to have_css('.thumb img', count: 1)

    click_delete_image!
    click_section_tab 'Photos'
    expect(page).to_not have_css('.thumb img')
  end

  scenario 'for a substructure' do
    window_type = create(:audit_strc_type,
                         name: 'Window',
                         parent_structure_type: audit.audit_structure.audit_strc_type)
    create(:audit_structure,
           name: 'My window',
           parent_structure: audit.audit_structure,
           audit_strc_type: window_type)
    visit current_path

    click_structure_row 'My window'
    click_section_tab 'Photos'
    expect(page).to_not have_css('.thumb img')
    upload_photo test_image_path
    click_section_tab 'Photos'
    expect(page).to have_css('.thumb img', count: 1)

    click_delete_image!
    click_section_tab 'Photos'
    expect(page).to_not have_css('.thumb img')
  end

  scenario 'when the audit is locked' do
    audit.update(locked_by: user)
    visit current_path

    click_section_tab 'Photos'
    expect(page).to_not have_field 'Upload image'
    expect(page).to_not have_css('.thumb .thumb__delete')
  end

  def click_delete_image!
    find('.thumb img').hover
    find('.thumb .thumb__delete').click
  end

  def upload_photo(path)
    execute_script '$(".js-upload-image").css("height", "auto");'
    attach_file 'Upload image', path
  end
end
