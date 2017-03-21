require 'features_helper'

feature 'download usage data from audit report', :js do
  include Features::CommonSupport
  include Features::DownloadSupport

  let!(:user) { create(:user) }
  let!(:structures) do
    [{ 'id' => 'id',
       'name' => 'panda express',
       'structure_type' => { 'name' => 'Building',
                             'api_name' => 'building' },
       'wegowise_id' => 123,
       'field_values' => {},
       'n_structures' => 1,
       'substructures' => []
      }]
  end

  before do
    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [],
      structures: structures,
      audit_name: 'audit with data'
    )
    click_link 'All reports'
  end

  scenario 'from reports index page' do
    click_link 'Download usage data'
    expect(page).to have_content 'No data available to download.'

    water_data = [
      { 'date' => '2015-01-01', 'value' => 1.0 },
      { 'date' => '2015-02-01', 'value' => 2.0 },
      { 'date' => '2015-03-01', 'value' => 3.0 }
    ]
    create(:building_monthly_datum,
           wegowise_id: 123,
           data_type: 'water',
           data: water_data)

    click_link 'Download usage data'

    expect_zip_file_download do |zip_file|
      expect(zip_file.entries.count).to eq 1
      entry = zip_file.entries.first
      expect(entry.name).to eq 'panda express - water.csv'

      expect(entry.get_input_stream.read.split("\n")).to eq(
        ['Water data for panda express',
         'Date,gallons',
         '2015-01-01,1.0',
         '2015-02-01,2.0',
         '2015-03-01,3.0']
      )
    end
  end

  def expect_zip_file_download
    wait_for_download
    expect(download).to match(/\.zip$/)
    Zip::File.open(download) do |zip_file|
      yield zip_file
    end
    clear_downloads
  end
end
