require 'features_helper'

feature 'Show calculation results for interior lighting', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }
  let!(:lighting) do
    create(:structure_type,
           name: 'Lighting',
           api_name: 'lighting',
           genus_api_name: 'lighting')
  end
  let!(:fluorescent) do
    create(:structure_type,
           name: 'Fluorescent lighting',
           api_name: 'fluorescent',
           genus_api_name: 'lighting')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'interior_lighting_and_controls')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'fluorescent',
          structure_type: fluorescent
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structure('fluorescent - White House', 'lighting')

    fill_out_structure_cards(
      '1 - Lighting',
      existing: {
        quantity: 50,
        lamps_per_fixture: 2,
        lamp_type: 'Fluorescent',
        watts_per_lamp: 32,
        ballast_type: 'magnetic',
        lighting_controls: 'Manual Switch'
      },
      proposed: {
        quantity: 50,
        lamp_type: 'LED',
        lighting_controls: 'Bi-level occupancy',
        bilevel_fixture_low_power_wattage: 5,
        bilevel_fixture_high_power_wattage: 20,
        per_fixture_cost: 75,
        wattage: 22
      }
    )

    fill_out_measure_level_fields(
      retrofit_lifetime: '20',
      operating_hours_per_week: 168
    )

    click_link 'Edit report data'
    fill_out_audit_level_fields(electric_cost_per_kwh: 0.124)
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_electric_savings: '37,097.0',
      annual_cost_savings: '$4,600.00',
      years_to_payback: '0.815',
      cost_of_measure: '$3,750.00',
      savings_investment_ratio: '24.5'
    )
  end
end
