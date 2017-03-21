require 'features_helper'

feature 'Change and validate fields', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport

  before do
    create(:field, name: 'Lamp type', api_name: 'bulb_type')
    create(:field,
           name: 'Watts per lamp',
           api_name: 'watts_per_lamp',
           value_type: 'decimal')
    Field.unmemoize_all

    MeasureDefinitionsRegistry.add_definition(
      :replace_lighting,
      inputs: {
        lighting: [
          :watts_per_lamp,
          :bulb_type
        ]
      },
      structures: {
        lighting: {
          multiple: true,
          field_for_grouping: :bulb_type
        }
      }
    )

    Kilomeasure.add_measure(
      :replace_lighting,
      inputs: {
        'lighting' => [:watts_per_lamp, :bulb_type]
      }
    )
  end

  let!(:user) { create(:user) }
  let!(:structure_type1) do
    create(:structure_type,
           name: 'Lighting',
           api_name: 'lighting',
           genus_api_name: 'lighting')
  end
  let!(:measure1) do
    create(:measure,
           name: 'Replace lighting',
           api_name: :replace_lighting)
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
          sample_group_id: nil,
          wegowise_id: 12_345,
          substructures: [
            { id: SecureRandom.uuid,
              name: 'Hallway lights',
              structure_type: { name: 'Lighting', api_name: 'lighting' },
              field_values: {
                watts_per_lamp: {
                  name: 'Watts per lamp',
                  value: 3,
                  value_type: 'integer' }
              },
              n_structures: 4,
              sample_group_id: nil
            }
          ]
        }
      ],
      audit_name: '123 Main St'
    )
  end

  scenario 'Inputting and resetting values' do
    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'lighting',
        options: [
          'Hallway lights - White House (4 total)',
          'New structure...'
        ])
      select_structure_option(
        'Hallway lights - White House (4 total)',
        api_name: 'lighting')
      click_button 'Next'
    end

    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        expect_structure_fields(watts_per_lamp: '3.0', bulb_type: '')

        fill_in_structure_name_field(value: 'My house')
        fill_in_structure_quantity_field(value: '2')
        fill_in_structure_field(api_name: 'watts_per_lamp', value: 10)
        fill_in_structure_field(api_name: 'bulb_type', value: 'Lava')

        expect_structure_name_field('My house')
        expect_structure_quantity_field('2')
        expect_structure_fields(watts_per_lamp: 10, bulb_type: 'Lava')
      end
    end

    # Check that changes are persisted
    visit current_path

    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        expect_structure_name_field('My house')
        expect_structure_quantity_field('2')
        expect_structure_fields(watts_per_lamp: '10.0', bulb_type: 'Lava')

        # Check that you can reset values to original audit values
        should_not_see_structure_field_reset_link(api_name: 'bulb_type')
        click_structure_field_reset_link(api_name: 'watts_per_lamp')
        click_structure_name_field_reset_link

        expect_structure_name_field('Hallway lights - White House')
        expect_structure_fields(watts_per_lamp: 3, bulb_type: 'Lava')
      end
    end

    visit current_path

    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        expect_structure_name_field('Hallway lights - White House')
        expect_structure_fields(watts_per_lamp: '3.0', bulb_type: 'Lava')
      end
    end
  end
end
