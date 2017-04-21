require 'features_helper'

feature 'Show calculation results for DHW Replacement', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:dhw) do
    create(:structure_type,
           name: 'DHW',
           api_name: 'domestic_hot_water_system',
           genus_api_name: 'domestic_hot_water_system')
  end
  let!(:measure1) { Measure.find_by!(api_name: 'dhw_replacement') }

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'DHW',
          structure_type: dhw
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('DHW - White House', dhw.api_name)

    fill_out_structure_cards(
      '1 - DHW',
      existing: { afue: 0.7, tank_efficiency: 0.8 },
      proposed: {
        afue: 0.92, tank_efficiency: 0.8, per_unit_cost: 9380 }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '20')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      heating_fuel_baseload_in_therms: 2061.20)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$492.90',
      annual_gas_savings: '493.0',
      years_to_payback: '19.0',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '1.05'
    )
  end
end
