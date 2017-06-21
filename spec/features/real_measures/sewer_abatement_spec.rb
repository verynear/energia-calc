require 'features_helper'

feature 'Show calculation results for Sewer Abatement', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:abatement_meter) do
    StructureType.find_by!(api_name: 'sewer_abatement_meter')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'sewer_abatement')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Sewer abatement meter',
          structure_type: abatement_meter
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('Sewer abatement meter - White House', abatement_meter.api_name)

    fill_out_structure_cards(
      '1 - Sewer Abatement Meter',
      proposed: {
        per_unit_cost: '500',
        abatement_system: 'Irrigation',
        annual_water_usage_through_meter: '1000',
        sewer_rate_per_gallon: '1'
      }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    # shouldn't be needed, but prevents a weird Selenium error locally
    click_link 'Edit report data'
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$1,000.00',
      annual_water_savings: '1,000.0',
      years_to_payback: '0.5',
      cost_of_measure: '$500.00',
      savings_investment_ratio: '20'
    )
  end
end
