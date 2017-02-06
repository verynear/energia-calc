module Helpers
  module Forms
    def select_date(date, options = {})
      field = options[:from]
      base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
      month, day, year = date.match(/(\w+) (\d+), (\d+)/).to_a[1..3]
      select month, from: "#{base_id}_2i"
      select day, from: "#{base_id}_3i"
      select year, from: "#{base_id}_1i"
    end
  end
end
