require 'features_helper'

feature 'Show calculation results for DHW Pipe Insulation', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:dhw) do
    create(:structure_type,
           name: 'DHW',
           api_name: 'domestic_hot_water_system',
           genus_api_name: 'domestic_hot_water_system')
  end
  let!(:distribution_system) do
    create(:structure_type,
           name: 'Distribution System',
           api_name: 'distribution_system',
           genus_api_name: 'distribution_system')
  end
  let!(:measure1) { Measure.find_by!(api_name: 'dhw_pipe_insulation') }

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'DHW',
          structure_type: dhw
        },
        {
          name: 'Pipes',
          structure_type: distribution_system
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structures(
      'DHW - White House' => dhw.api_name,
      'Pipes - White House' => distribution_system.api_name
    )

    fill_out_structure_cards(
      '1 - DHW',
      existing: {
        afue: 0.71,
        dhw_btu_per_hour: 398_000,
        tank_efficiency: 0.8
      },
      proposed: {
        afue: 0.71,
        tank_efficiency: 0.8
      }
    )

    fill_out_structure_cards(
      '2 - Distribution System',
      existing: {
        length_uninsulated_pipe: 400,
        length_insulated_pipe: 0
      },
      proposed: {
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 400,
        per_unit_cost: 3600
      }
    )

    fill_out_measure_level_fields(
      number_fires_per_day: 24,
      number_heater_days_per_year: 365,
      outer_pipe_diameter_in_inches: 1.05,
      r_value_of_pipe_insulation: 4.5,
      retrofit_lifetime: '20')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      heating_fuel_baseload_in_therms: 4654.96,
      gas_cost_per_therm: 1)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$379.86',
      annual_gas_savings: '380.0',
      years_to_payback: '9.48',
      cost_of_measure: '$3,600.00',
      savings_investment_ratio: '2.11'
    )
  end
end
