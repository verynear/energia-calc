require 'rails_helper'

feature 'Deleted audits', :js do
  let!(:user) { create(:user) }
  let!(:audit) do
    create(:audit, :deleted,
           name: 'My deleted audit',
           user: user)
  end

  before do
    signin_as(user)
    visit audits_path
    Timecop.freeze(DateTime.current.end_of_day)
  end

  after { Timecop.return }

  scenario 'viewing audits that have been marked for deletion' do
    audit_table_headers = [
       'Audit name',
      'Audit type',
      'Created by',
      'Performed on',
      'Expires in'
    ]
    audit_table_row = [
      'My deleted audit',
      audit.audit_type.name,
      user.full_name,
      audit.performed_on.strftime('%m/%d/%Y'),
      '29 days'
    ]

    click_link 'View deleted audits'
    should_see_table(audit_table_headers, [audit_table_row])
  end
end
