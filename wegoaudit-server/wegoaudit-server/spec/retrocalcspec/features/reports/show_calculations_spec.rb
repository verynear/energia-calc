require 'features_helper'

feature 'Show calculation results', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport

  before do
    setup_lighting_measure
  end
  let!(:infinity_symbol) { "\u221E" }
  let!(:user) { create(:user) }
  let!(:lighting) do
    create(:structure_type,
           name: 'Lighting',
           api_name: 'lighting',
           genus_api_name: 'lighting')
  end
  let!(:measure1) do
    Measure.find_by(name: 'Replace lighting')
  end

  before do
    set_up_audit_report_for_measures(
      [measure1],
      user: user,
      substructures: [
        { id: SecureRandom.uuid,
          name: 'Kitchen light',
          structure_type: lighting,
          field_values: {
            type_of_lightbulb: {
              name: 'Type of lightbulb',
              value: 'High-power',
              value_type: 'picker' }
          }
      }
      ]
    )
  end

  before do
    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      select_structure_option(
        'Kitchen light - White House',
        api_name: 'lighting')
      click_button 'Next'
    end

    # Set quantity to 1 for simplicity
    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_quantity_field(value: 1)
      end
      within_proposed_structure_card do
        fill_in_structure_quantity_field(value: 1)
      end
    end
  end

  scenario 'Viewing calculations' do
    expect_measure_summary_values(
      annual_cost_savings: 'Missing fields',
      annual_electric_savings: 'Missing fields',
      years_to_payback: 'Missing fields',
      cost_of_measure: 'Missing fields',
      savings_investment_ratio: 'Missing fields'
    )

    # Fill out fields needed for usage calculation
    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
      end
      within_proposed_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'Low-power')
      end
    end

    fill_in_measure_field(api_name: 'operating_hours_per_day', value: '10')

    # Usage savings calculation is updated
    expect_measure_summary_values(
      annual_cost_savings: 'Missing fields',
      annual_electric_savings: '3,650', # (3 * 1 * 10 * 365) - (2 * 1 * 10 * 365)
      years_to_payback: 'Missing fields',
      cost_of_measure: 'Missing fields',
      savings_investment_ratio: 'Missing fields'
    )

    # Fill out fields needed for cost calculation
    click_link 'Edit report data'
    fill_in_audit_report_field(api_name: 'electric_cost_per_kwh', value: '4')
    click_link 'Edit measures'

    expect_measure_summary_values(
      # (3 * 1 * 10 * 365 * 4) - (2 * 1 * 10 * 365 * 4)
      annual_cost_savings: '$14,600.00',
      annual_electric_savings: '3,650',
      years_to_payback: 'Missing fields',
      cost_of_measure: 'Missing fields',
      savings_investment_ratio: 'Missing fields'
    )

    # Fill out fields needed for investment return calculation
    within_structure_change_section('1 - Lighting') do
      within_proposed_structure_card do
        fill_in_structure_field(api_name: 'per_lamp_cost', value: '100')
      end
    end

    expect_measure_summary_values(
      annual_cost_savings: '$14,600.00',
      annual_electric_savings: '3,650',
      cost_of_measure: '$100.00',
      savings_investment_ratio: 'Missing fields',
      years_to_payback: '0.0068') # 100 / 14600 rounded up

    # Calculations change when you change quantity
    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_quantity_field(value: 5)
      end
      within_proposed_structure_card do
        fill_in_structure_quantity_field(value: 2)
      end
    end

    expect_measure_summary_values(
      # (3 * 1 * 5 * 4 * 365 * 10) - (2 * 1 * 2 * 4 * 365 * 10)
      annual_cost_savings: '$160,600.00',
      # (3 * 1 * 5 * 365 * 10) - (2 * 1 * 2 * 365 * 10)
      annual_electric_savings: '40,150',
      cost_of_measure: '$200.00',
      savings_investment_ratio: 'Missing fields',
      years_to_payback: '0.0012')

    # Confirm summary displays on refresh
    visit current_path
    expect_measure_summary_values(
      annual_cost_savings: '$160,600.00',
      annual_electric_savings: '40,150',
      cost_of_measure: '$200.00',
      savings_investment_ratio: 'Missing fields',
      years_to_payback: '0.0012')

    # Display savings investment ratio
    fill_in_measure_field(api_name: 'retrofit_lifetime', value: '12')
    expect_measure_summary_values(
      annual_cost_savings: '$160,600.00',
      annual_electric_savings: '40,150',
      cost_of_measure: '$200.00',
      savings_investment_ratio: '9636',
      years_to_payback: '0.0012')

    # Shows infinite payback time if savings is 0
    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_quantity_field(value: 1)
      end
      within_proposed_structure_card do
        fill_in_structure_quantity_field(value: 1)
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'High-power')
      end
    end

    # Shows infinite sir if cost of measure is 0
    within_structure_change_section('1 - Lighting') do
      within_proposed_structure_card do
        fill_in_structure_field(api_name: 'per_lamp_cost', value: '0')
      end
    end

    expect_measure_summary_values(
      annual_cost_savings: '$0.00',
      annual_electric_savings: '0',
      cost_of_measure: '$0.00',
      savings_investment_ratio: infinity_symbol,
      years_to_payback: infinity_symbol)
  end
end
