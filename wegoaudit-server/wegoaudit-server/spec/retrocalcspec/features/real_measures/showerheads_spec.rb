require 'features_helper'

feature 'Show calculation results for Showerheads', :js, :real_measure do
  include Features::CommonSupport

  let!(:user) { create(:user) }

  let!(:dhw) do
    create(:structure_type,
           name: 'Domestic Hot Water System',
           api_name: 'domestic_hot_water_system',
           genus_api_name: 'domestic_hot_water_system')
  end
  let!(:showerhead) do
    create(:structure_type,
           name: 'Showerhead',
           api_name: 'showerhead',
           genus_api_name: 'water')
  end
  let!(:measure1) do
    Measure.find_by!(api_name: 'showerheads')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        {
          name: 'Showerhead',
          structure_type: showerhead
        },
        {
          name: 'DHW',
          structure_type: dhw
        }
      ]
    )
  end

  scenario 'Verify measure' do
    add_new_structures(
      'DHW - White House' => dhw.api_name,
      'Showerhead - White House' => showerhead.api_name
    )

    fill_out_structure_cards(
      '1 - Domestic Hot Water System',
      existing: { afue: 0.7,
                  dhw_cold_water_temperature: 80,
                  dhw_hot_water_temperature: 130 },
      proposed: { dhw_cold_water_temperature: 80,
                  dhw_hot_water_temperature: 130 }
    )

    fill_out_structure_cards(
      '2 - Showerhead',
      existing: { gpm: 2.5 },
      proposed: { gpm: 1.5, per_unit_cost: 360 }
    )

    fill_out_measure_level_fields(
      retrofit_lifetime: '20'
    )

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      water_cost_per_gallon: 0.00844,
      num_apartments: 10,
      num_bedrooms: 10
    )
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_water_savings: '43,840',
      annual_gas_savings: '128.0',
      annual_cost_savings: '$498.40',
      cost_of_measure: '$360.00',
      years_to_payback: '0.722',
      savings_investment_ratio: '27.7'
    )
  end
end
