require 'features_helper'

feature 'Show calculation results for temp limiting controls', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:controls) do
    create(:structure_type,
           name: 'Controls',
           api_name: 'controls',
           genus_api_name: 'controls')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'install_temperature_limiting_thermostats')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Controls',
          structure_type: controls
        }
      ]
    )

    create(:hourly_temperature, date: '2015-09-16', temperature: 40.048)
    create(:hourly_temperature, date: '2015-06-14', temperature: 40.048)
    create(:hourly_temperature, date: '2015-08-01', temperature: 100)

    require 'rake'
    Retrocalc::Application.load_tasks
    Rake::Task['import:temperature_locations'].invoke
  end

  scenario 'Verify measure' do
    add_new_structure('Controls - White House', controls.api_name)

    fill_out_structure_cards(
      '1 - Controls',
      existing: {},
      proposed: {
        temperature_limit: 72, per_unit_cost: 1
      }
    )

    fill_out_measure_level_fields(
      retrofit_lifetime: '20',
      warm_weather_shutdown_temperature: 60
    )

    within_measure_summary do
      select_structure_field_option(
        api_name: :energy_source,
        value: 'gas')
    end

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      heating_degree_days: 5800,
      building_sqft: 50_000,
      heating_usage_in_therms: 23_205.5,
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1,
      average_indoor_temperature: 75,
      heating_season_start_month: '09-15',
      heating_season_end_month: '06-15'
    )
    select_structure_field_option(
      api_name: :location_for_temperatures,
      value: 'Boston')
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$1,991.77',
      annual_gas_savings: '1,992.0',
      annual_electric_savings: '0',
      years_to_payback: '0.0005',
      cost_of_measure: '$1.00',
      savings_investment_ratio: '39835.0'
    )

    # Switch energy source
    within_measure_summary do
      select_structure_field_option(
        api_name: :energy_source,
        value: 'electric')
    end

    expect_measure_summary_values(
      annual_cost_savings: '$58,358.99',
      annual_gas_savings: '0',
      annual_electric_savings: '58,359.0',
      years_to_payback: '0.0',
      cost_of_measure: '$1.00',
      savings_investment_ratio: '1167180.0'
    )
  end
end
