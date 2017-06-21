require 'features_helper'

feature 'user can create new report', :js do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:measure1) { create(:measure) }
  let!(:measure2) { create(:measure) }
  let!(:measure3) { create(:measure) }

  before do
    signin_as(user)
  end

  scenario 'selecting an audit imported from wegoaudit to work on' do
    uuid1 = SecureRandom.uuid
    uuid2 = SecureRandom.uuid

    stub_wegoaudit_request(
      '/audits',
      query: { wegowise_id: user.wegowise_id }) do
      { audits: [
        { id: uuid1,
          name: '123 Main St',
          date: '2015-05-01',
          audit_type: 'Water Only' },
        { id: uuid2,
          name: '1600 Pennsylvania',
          date: '2015-05-15',
          audit_type: 'Energy Savers Audit' }
      ] }
    end

    click_new_report_button

    should_see_modal('Create report') do
      expect_audits_table(
        [//, '123 Main St', '05/01/2015', 'Water Only'],
        [//, '1600 Pennsylvania', '05/15/2015', 'Energy Savers Audit']
      )

      stub_wegoaudit_request(
        "/audits/#{uuid1}",
        query: { wegowise_id: user.wegowise_id }) do
          audit_payload(
            id: uuid1,
            date: '2015-05-01',
            name: '123 Main St',
            audit_type: 'Water Only',
            structures: [],
            photos: [],
            measures: [
              { name: measure1.name, api_name: measure1.api_name },
              { name: measure3.name, api_name: measure3.api_name }])
        end

      choose('123 Main St')

      click_button 'Next'
    end

    expect(page).to have_content('Report based on "123 Main St"')

    expect_measure_tabs(measure1.name, measure3.name)

    click_link 'All reports'
    expect_audit_reports_table(
      ['123 Main St',
       Time.current.strftime('%m/%d/%Y'),
       /Edit report data\s+Download usage data\s+Edit measures\s+Edit PDF\s+Download PDF\s+Delete report/]
    )

    # Change name of report
    click_link 'Edit report data'
    fill_in_audit_report_name_field(value: '124 Main Ave')
    click_link 'All reports'
    expect_audit_reports_table(
      ['124 Main Ave',
       Time.current.strftime('%m/%d/%Y'),
       /Edit report data\s+Download usage data\s+Edit measures\s+Edit PDF\s+Download PDF\s+Delete report/]
    )
  end

  scenario 'when wegoaudit returns an error getting the audits list' do
    stub_wegoaudit_request(
      '/audits',
      query: { wegowise_id: user.wegowise_id }) do
      { error: { message: 'Something went wrong' } }
    end
    click_new_report_button

    should_see_modal('Create report') do
      expect_error_text('Error retrieving list of audits from WegoAudit')
    end
  end

  scenario 'when wegoaudit returns an error selecting an audit' do
    stub_wegoaudit_request(
      '/audits',
      query: { wegowise_id: user.wegowise_id }) do
      { audits: [
        { id: '123',
          name: '123 Main St',
          date: '2015-05-01',
          audit_type: 'Water Only' },
        { id: '456',
          name: '1600 Pennsylvania',
          date: '2015-05-15',
          audit_type: 'Energy Savers Audit' }
      ] }
    end

    click_new_report_button

    should_see_modal('Create report') do
      stub_wegoaudit_request(
        '/audits/123',
        query: { wegowise_id: user.wegowise_id }) do
        {
          error: {
            code: 'audit_not_found',
            message: 'Unable to find audit id 123' } }
      end

      choose('123 Main St')
      click_button 'Next'
    end

    expect_alert_notice('Error importing audit: Unable to find audit id 123')
    expect(page).to have_css '.js-new-report-button'
  end

  scenario 'when wegoaudit reports that user is not found' do
    stub_wegoaudit_request(
      '/audits',
      query: { wegowise_id: user.wegowise_id }) do
      { error: { code: 'user_not_found' } }
    end

    click_new_report_button

    expect(page).not_to have_content('Something went wrong')
    expect(page).to have_link('Create audits in WegoAudit')
  end
end
