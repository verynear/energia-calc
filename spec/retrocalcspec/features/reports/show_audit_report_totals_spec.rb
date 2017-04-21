require 'features_helper'

feature 'Show audit report summary totals', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport

  before do
    setup_lighting_measure
  end

  let!(:user) { create(:user) }
  let!(:structure_type1) do
    create(:structure_type,
           name: 'Lighting',
           api_name: 'lighting',
           genus_api_name: 'lighting')
  end
  let!(:measure1) do
    Measure.find_by!(name: 'Replace lighting')
  end

  before do
    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [
        { measure: measure1 }
      ],
      structures: [
        { id: SecureRandom.uuid,
          name: 'White House',
          structure_type: { name: 'Building', api_name: 'building' },
          field_values: {},
          n_structures: 1,
          wegowise_id: 12_345,
          substructures: [
            { id: SecureRandom.uuid,
              name: 'Kitchen light',
              structure_type: { name: 'Lighting', api_name: 'lighting' },
              field_values: {},
              n_structures: 1
            },
            { id: SecureRandom.uuid,
              name: 'Lava lamp',
              structure_type: { name: 'Lighting', api_name: 'lighting' },
              field_values: {},
              n_structures: 1
            }
          ]
        }
      ],
      audit_name: '123 Main St'
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
  end

  scenario 'Viewing total calculations' do
    expect_audit_report_summary_values(
      cost_of_measure: '?',
      annual_cost_savings: '?',
      annual_energy_savings: '?',
      annual_water_savings: '?',
      years_to_payback: '?',
      utility_rebate: '?'
    )

    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'High-power')
      end
      within_proposed_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'Low-power')
        fill_in_structure_field(api_name: 'per_lamp_cost', value: '100')
      end
    end

    within_measure_summary do
      fill_in_structure_field(api_name: 'operating_hours_per_day', value: '10')
    end

    click_link 'Edit report data'
    fill_in_audit_report_field(api_name: 'electric_cost_per_kwh', value: '4')
    click_link 'Edit measures'

    expect_audit_report_summary_values(
      cost_of_measure: '$100.00',
      annual_cost_savings: '$14,600.00',
      annual_energy_savings: '12,453,800.0',
      annual_water_savings: '?',
      years_to_payback: '0.0068',
      utility_rebate: '?'
    )

    # add a new measure
    click_link 'Add measure'
    should_see_modal('Add a new measure to this report') do
      select 'Replace lighting', from: 'measure_selection[measure_id]'
      click_button 'Add measure'
    end

    expect_audit_report_summary_values(
      cost_of_measure: '$100.00',
      annual_cost_savings: '$14,600.00',
      annual_energy_savings: '12,453,800.0',
      annual_water_savings: '?',
      years_to_payback: '0.0068',
      utility_rebate: '?'
    )

    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      select_structure_option(
        'Kitchen light - White House',
        api_name: 'lighting')
      click_button 'Next'
    end

    # fill in new measure with the same values, for easier calculations
    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'High-power')
      end
      within_proposed_structure_card do
        fill_in_structure_field(api_name: 'total_number_of_lamps', value: '1')
        select_structure_field_option(
          api_name: 'type_of_lightbulb',
          value: 'Low-power')
        fill_in_structure_field(api_name: 'per_lamp_cost', value: '100')
      end
    end

    within_measure_summary do
      fill_in_structure_field(api_name: 'operating_hours_per_day', value: '10')
    end

    expect_audit_report_summary_values(
      cost_of_measure: '$200.00',
      annual_cost_savings: '29,200.00',
      annual_energy_savings: '24,907,600.0',
      annual_water_savings: '?',
      years_to_payback: '0.0137',
      utility_rebate: '?'
    )

    # remove this measure from report calculations
    uncheck 'enable-measure'

    expect_audit_report_summary_values(
      cost_of_measure: '$100.00',
      annual_cost_savings: '$14,600.00',
      annual_energy_savings: '12,453,800.0',
      annual_water_savings: '?',
      years_to_payback: '0.0068',
      utility_rebate: '?'
    )

    # include this measure in calculations again
    check 'enable-measure'

    expect_audit_report_summary_values(
      cost_of_measure: '$200.00',
      annual_cost_savings: '29,200.00',
      annual_energy_savings: '24,907,600.0',
      annual_water_savings: '?',
      years_to_payback: '0.0137',
      utility_rebate: '?'
    )
  end
end
