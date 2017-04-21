require 'features_helper'

feature 'Show calculation results for Duct air sealing', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:distribution_system) do
    create(:structure_type,
           name: 'Distribution system',
           api_name: 'distribution_system',
           genus_api_name: 'distribution_system')
  end
  let!(:measure1) { Measure.find_by!(api_name: 'duct_air_sealing') }

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Ducts',
          structure_type: distribution_system
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Ducts - White House', distribution_system.api_name)

    fill_out_structure_cards(
      '1 - Distribution system',
      proposed: {
        leakage: 'No observable leaks',
        r_value: '8',
        annual_heating_savings: '1500',
        annual_cooling_savings: '500',
        percentage_within_conditioned_space: '80',
        cooling_capacity: '95',
        heating_capacity: '95',
        seer_cooling_efficiency: '95',
        heating_efficiency: '65',
        per_unit_cost: '4000' }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$2,000.00',
      annual_gas_savings: '1,500.0',
      annual_electric_savings: '500.0',
      years_to_payback: '2',
      cost_of_measure: '$4,000.00',
      savings_investment_ratio: '5'
    )
  end
end
