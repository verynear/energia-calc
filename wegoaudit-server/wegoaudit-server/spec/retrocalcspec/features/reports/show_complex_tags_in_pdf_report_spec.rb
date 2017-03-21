require 'features_helper'

feature 'Show tags in pdf report', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport
  include Features::WebSupport

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
              photos: [
                { id: 'foo',
                  medium_url: 'photo1_medium_url',
                  thumb_url: 'photo1_thumb_url' }
              ],
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
      fill_in_structure_field(api_name: 'utility_rebate', value: '5')
      fill_in_structure_field(api_name: 'retrofit_lifetime', value: '12')
      fill_in_description_field('brand new bulb')
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
      utility_rebate: '$5.00'
    )
  end

  scenario 'Show complex tags from audit report' do
    create_report_template('recommendations', '{% recommendations_table %}')

    click_link 'Edit PDF report'
    select_template 'recommendations'
    click_button 'Save'

    within_pdf_preview do
      expect_recommendations_table(
        ['1. Replace lighting: brand new bulb',
         '$100.00',
         '$14,600.00',
         '3,650',
         '0.0068',
         '12.0',
         '1752.0',
         '5.0']
      )
    end

    # Add new recommendation
    click_link 'Back: Edit measures'

    click_link 'Add measure'
    should_see_modal('Add a new measure to this report') do
      select 'Replace lighting', from: 'measure_selection[measure_id]'
      click_button 'Add measure'
    end

    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      select_structure_option(
        'Kitchen light - White House',
        api_name: 'lighting')
      click_button 'Next'
    end
    should_not_see_modal

    click_link 'Edit PDF report'

    within_pdf_preview do
      expect_recommendations_table(
        ['1. Replace lighting: brand new bulb',
         '$100.00',
         '$14,600.00',
         '3,650',
         '0.0068',
         '12.0',
         '1752.0',
         '5.0'],
        ['2. Replace lighting',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields']
      )
    end

    # Change order of recommendations

    click_link 'Back: Edit measures'
    drag_and_drop('.js-measure-tab:nth-of-type(1)',
                  '.js-measure-tab:nth-of-type(2)')
    click_link 'Edit PDF report'

    within_pdf_preview do
      expect_recommendations_table(
        ['1. Replace lighting',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields',
         'Missing fields'],
        ['2. Replace lighting: brand new bulb',
         '$100.00',
         '$14,600.00',
         '3,650',
         '0.0068',
         '12.0',
         '1752.0',
         '5.0']
      )
    end

    # Disable a measure and make sure it doesn't appear in table

    click_link 'Back: Edit measures'
    uncheck 'enable-measure'
    click_link 'Edit PDF report'

    within_pdf_preview do
      expect_recommendations_table(
        ['1. Replace lighting: brand new bulb',
         '$100.00',
         '$14,600.00',
         '3,650',
         '0.0068',
         '12.0',
         '1752.0',
         '5.0']
      )
    end
  end

  scenario 'Show measure images' do
    create_report_template('measures', '{% measures_list %}')

    select_image 'foo'

    click_link 'Edit PDF report'
    select_template 'measures'
    click_button 'Save'

    within_pdf_preview do
      expect(page).to have_content 'Replace lighting'
      expect(page).to have_css('img[src=photo1_thumb_url]')
    end

    # Add another measure, but don't select an image
    click_link 'Back: Edit measures'

    click_link 'Add measure'
    should_see_modal('Add a new measure to this report') do
      select 'Replace lighting', from: 'measure_selection[measure_id]'
      click_button 'Add measure'
    end

    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      select_structure_option(
        'Kitchen light - White House',
        api_name: 'lighting')
      click_button 'Next'
    end
    should_not_see_modal

    click_link 'Edit PDF report'

    within_pdf_preview do
      expect(page).to have_content 'Replace lighting'
      expect(page).to have_css('img[src=photo1_thumb_url]')
      expect(page).to have_content 'No image selected'
    end
  end
end
