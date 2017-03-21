require 'features_helper'

feature 'Show calculation results for Toilet Replacement', :js, :real_measure do
  include Features::CommonSupport
  include Features::AuditReportSupport

  let!(:user) { create(:user) }
  let!(:toilet) do
    create(:structure_type,
           name: 'Toilet',
           api_name: 'toilet',
           genus_api_name: 'toilet')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'toilet_replacement')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Toilet',
          structure_type: toilet
        }
      ]
    )
  end

  scenario 'Without leakage' do
    add_new_structure('Toilet - White House', toilet.api_name)

    fill_out_structure_cards(
      '1 - Toilet',
      existing: { percent_leaking: 0, daily_leakage: 0 },
      proposed: {
        percent_leaking: 0, daily_leakage: 0, per_unit_cost: 250 }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '15')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      water_cost_per_gallon: 0.00764,
      num_occupants: 20,
      num_bathrooms: 12)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$619.07',
      annual_water_savings: '81,030',
      years_to_payback: '4.8',
      cost_of_measure: '$3,000.00',
      savings_investment_ratio: '3.1'
    )
  end

  scenario 'With leakage' do
    add_new_structure('Toilet - White House', toilet.api_name)

    fill_out_structure_cards(
      '1 - Toilet',
      existing: {
        percent_leaking: 1,
        daily_leakage: 22,
        rated_gallons_per_flush: 1.6
      },
      proposed: {
        percent_leaking: 0,
        daily_leakage: 0,
        per_unit_cost: 250,
        rated_gallons_per_flush: 1.28
      }
    )
    fill_out_measure_level_fields(retrofit_lifetime: '15')

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      water_cost_per_gallon: 0.00844,
      num_occupants: 20,
      num_bathrooms: 12)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_cost_savings: '$911.86',
      annual_water_savings: '108,040',
      years_to_payback: '3.29',
      cost_of_measure: '$3,000.00',
      savings_investment_ratio: '4.56'
    )
  end
end
