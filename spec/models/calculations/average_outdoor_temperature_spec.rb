require 'rails_helper'

describe Calculations::AverageOutdoorTemperature do
  before do
    create(:hourly_temperature, date: '2015-06-16', temperature: '65')
    create(:hourly_temperature, date: '2015-06-15', temperature: '60')
    create(:hourly_temperature, date: '2015-09-15', temperature: '30')
    create(:hourly_temperature, date: '2015-09-14', temperature: '65')
  end

  it 'averages temperatures within the time range' do
    temp = described_class.new(
      location: 'Boston',
      heating_season_start_month: '09-15',
      heating_season_end_month: '06-15',
      warm_weather_shutdown_temperature: 70
    ).call
    expect(temp).to eq(45)
  end

  it 'restricts temperatures that are below a warm-weather cutoff' do
    temp = described_class.new(
      location: 'Boston',
      heating_season_start_month: '09-15',
      heating_season_end_month: '06-15',
      warm_weather_shutdown_temperature: 60
    ).call
    expect(temp).to eq(30)
  end
end
