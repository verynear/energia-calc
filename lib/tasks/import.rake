require 'csv'

namespace :import do
  desc 'Import temperatures from a directory of tmy3 files'
  task :temperatures, [:directory] => :environment do |_task, args|
    # Download files from
    # http://rredc.nrel.gov/solar/old_data/nsrdb/1991-2005/tmy3/zip/alltmy3a.zip
    directory = args[:directory]
    raise 'directory required' unless directory
    ActiveRecord::Base.connection.execute(
      'TRUNCATE hourly_temperatures RESTART IDENTITY'
    )

    rows_to_insert = Dir["#{directory}/*.CSV"].flat_map do |filename|
      lines = File.readlines(filename)
      first_line = CSV.parse(lines[0]).first
      location = first_line[1]
      state_code = first_line[2]

      csv_contents = lines[1..-1].join
      rows = CSV.parse(csv_contents, headers: true)
      rows_to_insert = rows.map do |row|
        date = Date.strptime(row['Date (MM/DD/YYYY)'], '%m/%d/%Y')
        temperature = row['Dry-bulb (C)']
        hour = row['Time (HH:MM)']
        raise 'Missing data' unless date && hour && temperature
        hour = hour.match(/\A0?(\d+):\d{2}\z/)[1]

        # Convert to fahrenheit
        temperature = (temperature.to_f * 1.8) + 32
        [date, temperature, hour, location, state_code]
      end
      HourlyTemperature.import(
        [:date, :temperature, :hour, :location, :state_code],
        rows_to_insert)
    end
  end

  desc 'Import structure_types from Wegoaudit'
  task structure_types: :environment do
    begin
      WegoauditDataImporter.new.import!
    rescue Faraday::ConnectionFailed
      puts "Couldn't connect to corresponding Wegoaudit instance!"
      exit unless Rails.env.development?
    end
  end

  desc 'base report templates'
  task report_templates: :environment do
    wego_org_names = {
      'elevate' => 'Elevate Energy',
      'nei' => 'New Ecology',
      'test' => 'Retrocalc Testers'
    }

    fixtures_path = Rails.root.join('db', 'fixtures', 'markdown')
    Dir[fixtures_path.join('**/*.md')].each do |markdown_file|
      org_name = File.dirname(markdown_file).split('/')[-1]
      template_name =
        "#{org_name} #{File.basename(markdown_file, '.md')}".titleize
      markdown = File.read(markdown_file)

      organization = CalcOrganization.find_by(name: wego_org_names[org_name])
      report_template = ReportTemplate.find_or_create_by!(
        name: template_name,
        layout: org_name)
      report_template.update!(
        markdown: markdown,
        layout: org_name,
        organization: organization)
    end
  end

  desc 'Create temperature locations from hourly temperatures'
  task temperature_locations: :environment do
    ActiveRecord::Base.connection.execute(
      'TRUNCATE temperature_locations RESTART IDENTITY'
    )
    HourlyTemperature.order(:location).uniq
      .pluck_to_hash(:location, :state_code).map do |row|
      TemperatureLocation.create!(
        location: row[:location],
        state_code: row[:state_code]
      )
    end
  end
end
