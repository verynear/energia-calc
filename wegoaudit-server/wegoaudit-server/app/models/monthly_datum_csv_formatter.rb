require 'csv'

class MonthlyDatumCsvFormatter
  attr_reader :monthly_datum,
              :structure_name

  def initialize(monthly_datum, structure_name)
    @monthly_datum = monthly_datum
    @structure_name = structure_name
  end

  def to_csv
    CSV.generate do |csv|
      csv << [header_text]
      csv << column_titles
      rows.each { |row| csv << row }
    end
  end

  private

  def column_titles
    ['Date'] << units.fetch(monthly_datum.data_type)
  end

  def header_text
    "#{monthly_datum.data_type.capitalize} data for #{structure_name}"
  end

  def rows
    monthly_datum.data.map(&:values)
  end

  def units
    { 'water' => 'gallons',
      'electric' => 'btu',
      'gas' => 'btu',
      'oil' => 'btu' }
  end
end
