require 'features_helper'

feature 'Show calculation results for steam vent replacement', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:steam_vent) do
    StructureType.create!(
      name: 'Steam vent',
      api_name: 'distribution_system',
      genus_api_name: 'distribution_system')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'steam_vent_replacement')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Vents',
          structure_type: steam_vent
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Vents - White House', steam_vent.api_name)

    fill_out_structure_cards(
      '1 - Steam vent',
      proposed: {
        input_annual_gas_savings: '1000',
        per_unit_cost: '2000'
      }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    click_link 'Edit report data'
    fill_out_audit_level_fields(gas_cost_per_therm: 1)

    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$1,000.00',
      annual_gas_savings: '1,000.0',
      years_to_payback: '2',
      cost_of_measure: '$2,000.00',
      savings_investment_ratio: '5'
    )
  end
end
