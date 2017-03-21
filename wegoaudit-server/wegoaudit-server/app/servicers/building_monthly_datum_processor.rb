# This class checks to see if there are 12 consecutive months of data
# in the response from wegowise, and sums the monthly values if so.
#
class BuildingMonthlyDatumProcessor < Generic::Strict
  attr_accessor :datum

  class MonthlyDatum < Generic::Strict
    attr_accessor :date,
                  :value
  end

  def execute
    yearly_data = sum_monthly_data_if_possible
    datum.update(yearly_data: yearly_data)
  end

  private

  def monthly_data
    datum.data
  end
  memoize :monthly_data

  def monthly_data_with_dates
    monthly_data.map do |data|
      date_string = data['date']
      value = data['value']

      date = Date.strptime(date_string, '%Y-%m-%d')
      MonthlyDatum.new(date: date, value: value)
    end
  end

  def sorted_monthly_data
    monthly_data_with_dates.sort_by(&:date)
  end
  memoize :sorted_monthly_data

  def spans_one_year?(data)
    date1 = data.first.date
    date2 = data.last.date
    date1 + 11.months == date2
  end

  def sum_monthly_data_if_possible
    return if monthly_data.length < 12

    (sorted_monthly_data.length - 1).downto(11).each do |index|
      range = (index - 11)..index
      subarray = sorted_monthly_data[range]
      next unless spans_one_year?(subarray)
      return sum_of_values(subarray)
    end

    nil
  end

  def sum_of_values(data)
    data.map(&:value).reduce(0.0) { |total, val| total + val }
  end
end
