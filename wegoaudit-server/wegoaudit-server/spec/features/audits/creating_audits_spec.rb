require 'rails_helper'

feature 'Creating audits', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:foo_audit_type) { create(:audit_type, name: 'Foo Audits') }
  let!(:bar_audit_type) { create(:audit_type, name: 'Bar Audits') }
  let!(:audit_structure_type) { create(:audit_structure_type) }

  before do
    signin_as(user)
    visit audits_path
  end

  scenario 'with defaults' do
    click_link 'New audit'
    fill_in 'Name', with: 'My bar audit'
    click_button 'Create'

    should_see_audits_table [
      ['My bar audit',
         'Bar Audits',
         user.full_name,
         Date.current.strftime('%m/%d/%Y')]
    ]

    # the 'audit structure' is created
    audit = Audit.last
    expect(audit.structure).to be_present
    expect(audit.structure.name).to eq audit.name
    expect(audit.structure.structure_type.name).to eq 'Audit'
  end

  scenario 'when selecting a non-default audit type' do
    click_link 'New audit'
    fill_in 'Name', with: 'My foo audit'
    select 'Foo Audits', from: 'Type'
    click_button 'Create'

    should_see_audits_table [
      ['My foo audit',
         'Foo Audits',
         user.full_name,
         Date.current.strftime('%m/%d/%Y')]
    ]
  end

  scenario 'when selecting a non-default performed on date' do
    click_link 'New audit'
    fill_in 'Name', with: 'My old audit'
    select_date 'January 1, 2011', from: 'Date'
    click_button 'Create'

    should_see_audits_table [
      ['My old audit',
         'Bar Audits',
         user.full_name,
         Date.new(2011, 1, 1).strftime('%m/%d/%Y')]
    ]
  end

  def should_see_audits_table(rows, matcher = 'table')
    should_see_table ['Audit name', 'Audit type', 'Created by', 'Performed on'],
                     rows,
                     matcher
  end
end
