module Calculations
  # Get hourly data points that are within a "heating season" (e.g. September to
  # June) and below a warm weather set point.
  #
  class AverageOutdoorTemperature < Generic::Strict
    attr_accessor :heating_season_end_month,
                  :heating_season_start_month,
                  :location,
                  :warm_weather_shutdown_temperature

    def call
      return unless location
      return unless heating_season_start_month
      return unless heating_season_end_month

      regexp = /\A0?(\d+)-0?(\d+)\z/
      start_pieces = heating_season_start_month.match(regexp)
      start_month = start_pieces[1]
      start_day = start_pieces[2]

      end_pieces = heating_season_end_month.match(regexp)
      end_month = end_pieces[1]
      end_day = end_pieces[2]

      result = HourlyTemperature.where(
        location: location
      )
        .where(
          "date NOT BETWEEN
            (CONCAT_WS('-', EXTRACT(year from date), ?, ?)::timestamp + INTERVAL '1 day')
          AND
            (CONCAT_WS('-', EXTRACT(year from date), ?, ?)::timestamp - INTERVAL '1 day')",
          end_month, end_day, start_month, start_day)
        .where('temperature < ?', warm_weather_shutdown_temperature)
        .pluck('AVG(temperature)')
      result.first
    end
  end
end
