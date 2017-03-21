require 'features_helper'

feature 'Show calculation results for solar thermal', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }

  let!(:solar_thermal) { StructureType.find_by!(api_name: 'solar_thermal') }
  let!(:measure1) do
    Measure.find_by!(api_name: 'solar_thermal')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Solar thermal',
          structure_type: solar_thermal
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Solar thermal - White House', solar_thermal.api_name)

    fill_out_structure_cards(
      '1 - Solar Thermal Potential',
      proposed: {
        input_annual_gas_savings: '1000',
        input_annual_electric_savings: '1000',
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
      annual_gas_savings: '1,000.0',
      annual_electric_savings: '1,000.0',
      years_to_payback: '2',
      cost_of_measure: '$4,000.00',
      savings_investment_ratio: '5'
    )
  end
end
