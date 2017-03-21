require 'features_helper'

feature 'Show calculation results for ventilation', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }

  let!(:ventilation_system) do
    StructureType.find_by!(api_name: 'ventilation_system')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'upgrade_ventilation_system')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Ventilation system',
          structure_type: ventilation_system
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure(
      'Ventilation system - White House',
      ventilation_system.api_name)

    fill_out_structure_cards(
      '1 - Ventilation System',
      proposed: {
        input_annual_gas_savings: '1000',
        input_annual_electric_savings: '2000',
        input_annual_oil_savings: '3000',
        per_unit_cost: '4000',
        air_volume_in_cfm_existing: '150',
        air_volume_in_cfm_proposed: '200' }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1,
      oil_cost_per_btu: 1)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$6,000.00',
      annual_gas_savings: '1,000.0',
      annual_electric_savings: '2,000.0',
      annual_oil_savings: '3,000.0',
      years_to_payback: '0.667',
      cost_of_measure: '$4,000.00',
      savings_investment_ratio: '15.0'
    )
  end
end
