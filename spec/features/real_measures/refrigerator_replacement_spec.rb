require 'features_helper'

feature 'Show calculation results for Refrigerator Replacement', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:refrigerator) do
    StructureType.find_by!(api_name: 'refrigerator')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'refrigerator_replacement')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Refrigerator',
          structure_type: refrigerator
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Refrigerator - White House', refrigerator.api_name)

    fill_out_structure_cards(
      '1 - Refrigerator',
      existing: {
        quantity: 90,
        refrigerator_size_in_cf: 18,
        manufactured_year: '1976 - 86'
      },
      proposed: {
        quantity: 90,
        refrigerator_size_in_cf: 18,
        energy_star_tier_of_refrigerator: 'CEE Tier 3',
        per_unit_cost: 510
      }
    )

    fill_out_measure_level_fields(retrofit_lifetime: 12)

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      electric_cost_per_kwh: 0.1
    )
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$9,495.00',
      annual_electric_savings: '94,950',
      years_to_payback: '4.83',
      cost_of_measure: '$45,900.00',
      savings_investment_ratio: '2.48'
    )
  end
end
