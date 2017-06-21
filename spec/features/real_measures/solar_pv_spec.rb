require 'features_helper'

feature 'Show calculation results for Solar PV', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:solar_pv) { StructureType.find_by!(api_name: 'solar_pv') }
  let!(:measure1) do
    Measure.find_by!(api_name: 'solar_pv')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Solar PV',
          structure_type: solar_pv
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Solar PV - White House', solar_pv.api_name)

    fill_out_structure_cards(
      '1 - Solar Potential',
      proposed: {
        initial_cost: '5000',
        potential_incentives: '1000',
        annual_electric_output: '2000',
        annual_solar_radiation: '10000',
        energy_value: '4000'
      }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    # shouldn't be needed, but prevents a weird Selenium error locally
    click_link 'Edit report data'
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$4,000.00',
      annual_electric_savings: '2,000.0',
      years_to_payback: '1',
      cost_of_measure: '$4,000.00',
      savings_investment_ratio: '10'
    )
  end
end
