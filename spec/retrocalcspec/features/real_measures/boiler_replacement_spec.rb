require 'features_helper'

feature 'Show calculation results for boiler replacement', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:distribution_system) do
    create(:structure_type,
           name: 'Distribution System',
           api_name: 'distribution_system',
           genus_api_name: 'distribution_system')
  end
  let!(:heating_system) do
    create(:structure_type,
           name: 'Heating System',
           api_name: 'heating_system',
           genus_api_name: 'heating_system')
  end
  let!(:measure1) { Measure.find_by!(api_name: 'boiler_replacement') }

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Boiler',
          structure_type: heating_system
        },
        {
          name: 'Pipes',
          structure_type: distribution_system
        }
      ]
    )
  end

  scenario 'with steam as working fluid' do
    add_new_structures(
      'Boiler - White House' => heating_system.api_name,
      'Pipes - White House' => distribution_system.api_name
    )

    fill_out_structure_cards(
      '1 - Distribution System',
      existing: {
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'mild steel',
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 450
      },
      proposed: {
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'mild steel',
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 450
      }
    )

    fill_out_structure_cards(
      '2 - Heating System',
      existing: {
        afue: 0.7,
        boiler_input_btu_per_hour: 2_860_000,
        working_fluid: 'steam'
      },
      proposed: {
        afue: 0.82,
        boiler_input_btu_per_hour: 2_860_000,
        working_fluid: 'steam',
        per_unit_cost: 36_270
      }
    )

    fill_out_measure_level_fields(
      retrofit_lifetime: '15')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      heating_usage_in_therms: 28_261,
      gas_cost_per_therm: 1)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$4,146.11',
      annual_gas_savings: '4,146.0',
      years_to_payback: '8.75',
      cost_of_measure: '$36,270.00',
      savings_investment_ratio: '1.71'
    )
  end

  scenario 'with water as working fluid' do
    add_new_structures(
      'Boiler - White House' => heating_system.api_name,
      'Pipes - White House' => distribution_system.api_name
    )

    fill_out_structure_cards(
      '1 - Distribution System',
      existing: {
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'cast iron',
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 150
      },
      proposed: {
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'cast iron',
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 150
      }
    )

    fill_out_structure_cards(
      '2 - Heating System',
      existing: {
        afue: 0.68,
        boiler_input_btu_per_hour: 300_000,
        working_fluid: 'water'
      },
      proposed: {
        afue: 0.92,
        boiler_input_btu_per_hour: 300_000,
        working_fluid: 'water',
        per_unit_cost: 30_000
      }
    )

    fill_out_measure_level_fields(
      retrofit_lifetime: '20')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      heating_usage_in_therms: 6_036,
      gas_cost_per_therm: 1)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$1,583.17',
      annual_gas_savings: '1,583.0',
      years_to_payback: '18.9',
      cost_of_measure: '$30,000.00',
      savings_investment_ratio: '1.06'
    )
  end
end
