require 'rails_helper'

feature 'Cloning audits', :omniauth, :js do
  let!(:user) { create(:user) }
  let!(:foo_audit_type) { create(:audit_type, name: 'Foo Audits') }
  let!(:bar_audit_type) { create(:audit_type, name: 'Bar Audits') }
  let!(:audit_structure_type) { create(:audit_audit_strc_type) }
  let!(:existing_audit) do
    create(:audit,
           audit_type: foo_audit_type,
           name: 'My existing audit',
           user: user)
  end

  before do
    signin_as(user)
    visit audits_path
  end

  scenario 'with defaults' do
    click_audit 'My existing audit', action: 'Clone'
    fill_in 'Name', with: 'My cloned audit'
    click_button 'Create'

    should_see_audits_table([
      ['My cloned audit', 'Foo Audits', user.full_name],
      ['My existing audit', 'Foo Audits', user.full_name]
    ])
  end

  scenario 'with a custom publish date' do
    click_audit 'My existing audit', action: 'Clone'
    fill_in 'Name', with: 'My cloned audit'
    select_date 'October 21, 2015', from: 'Date'
    click_button 'Create'

    should_see_audits_table [
      [
        'My cloned audit',
        'Foo Audits',
        user.full_name,
        '10/21/2015'
      ],
      [
        'My  existing audit',
        'Foo Audits',
        user.full_name,
        existing_audit.performed_on.strftime('%m/%d/%Y')
      ]
    ]
  end

  def should_see_audits_table(rows, matcher = 'table')
    should_see_table ['Audit name', 'Audit type', 'Created by', 'Performed on'],
                     rows,
                     matcher
  end
end

