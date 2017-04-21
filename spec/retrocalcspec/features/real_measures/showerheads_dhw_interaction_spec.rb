require 'features_helper'

feature 'Interactions between showerhead and DHW', :js, :real_measure do
  include Features::CommonSupport
  include Features::WebSupport

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
  let!(:measure2) do
    Measure.find_by!(api_name: 'dhw_replacement')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1, measure2],
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

  scenario 'Showerhead then DHW, then reverse order' do
    # First Showerhead
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
      retrofit_lifetime: '10'
    )

    click_link 'Edit report data'
    fill_out_audit_level_fields(
      gas_cost_per_therm: 1,
      water_cost_per_gallon: 0.00844,
      heating_fuel_baseload_in_therms: 2061.20,
      num_occupants: 20,
      num_apartments: 12
    )
    click_link 'Edit measures'

    expect_measure_summary_values(
      annual_water_savings: '43,840',
      annual_gas_savings: '128.0',
      annual_cost_savings: '$498.40',
      cost_of_measure: '$360.00',
      years_to_payback: '0.722',
      savings_investment_ratio: '13.8'
    )

    within_structure_change_section('1 - Domestic Hot Water System') do
      within_original_structure_card do
        expect_effective_structure_field('afue', '0.7')
      end
    end

    # Now DHW
    select_measure_tab(measure2.name)

    add_new_structure('DHW - White House', dhw.api_name)

    fill_out_structure_cards(
      '1 - Domestic Hot Water System',
      existing: { tank_efficiency: 0.8 },
      proposed: {
        afue: 0.92, tank_efficiency: 0.8, per_unit_cost: 9380 }
    )

    fill_out_measure_level_fields(retrofit_lifetime: '10')

    # These numbers are off from document
    expect_measure_summary_values(
      annual_cost_savings: '$462.19',
      annual_gas_savings: '462.0',
      years_to_payback: '20.3',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '0.493'
    )

    within_structure_change_section('1 - Domestic Hot Water System') do
      within_original_structure_card do
        expect_effective_structure_field('afue', '0.7')
      end
    end

    # Now reverse order
    drag_and_drop(".js-measure-tab:contains('#{measure1.name}')",
                  ".js-measure-tab:contains('#{measure2.name}')")
    expect_measure_tabs(measure2.name, measure1.name)

    # DHW
    select_measure_tab(measure2.name)
    expect_measure_summary_values(
      annual_cost_savings: '$492.90',
      annual_gas_savings: '493.0',
      years_to_payback: '19.0',
      cost_of_measure: '$9,380.00',
      savings_investment_ratio: '0.526'
    )

    within_structure_change_section('1 - Domestic Hot Water System') do
      within_original_structure_card do
        expect_effective_structure_field('afue', '0.7')
      end
    end

    # Showerhead
    select_measure_tab(measure1.name)
    # this is different from document
    expect_measure_summary_values(
      annual_water_savings: '43,840',
      annual_gas_savings: '97.7',
      annual_cost_savings: '$467.70',
      cost_of_measure: '$360.00',
      years_to_payback: '0.77',
      savings_investment_ratio: '13.0'
    )

    within_structure_change_section('1 - Domestic Hot Water System') do
      within_original_structure_card do
        expect_effective_structure_field('afue', '0.92')
      end
    end
  end
end
