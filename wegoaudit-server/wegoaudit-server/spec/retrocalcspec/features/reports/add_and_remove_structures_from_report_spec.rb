require 'features_helper'

feature 'add and remove structures from report', :js do
  include Features::CommonSupport
  include Features::AuditReportSupport

  before do
    create(:field,
           name: 'Watts per lamp',
           api_name: 'watts_per_lamp',
           value_type: 'decimal')
    create(:field, name: 'Lampshade Style', api_name: 'lampshade_style')
    create(:field, name: 'Mix setting', api_name: 'mix_setting')
    Field.unmemoize_all

    MeasureDefinitionsRegistry.add_definition(
      :lighting,
      inputs: {
        lighting: [
          :watts_per_lamp,
          :lampshade_style
        ]
      },
      structures: {
        lighting: {
          multiple: true,
          field_for_grouping: :lampshade_style
        }
      }
    )

    MeasureDefinitionsRegistry.add_definition(
      :replace_blender,
      inputs: {
        blender: [
          :mix_setting
        ]
      }
    )

    Kilomeasure.add_measure(
      :lighting,
      inputs: [:watts_per_lamp, :lampshade_style]
    )

    Kilomeasure.add_measure(
      'replace_blender',
      inputs: [:mix_setting]
    )
  end

  let!(:user) { create(:user) }
  let!(:genus_structure_type) do
    create(:structure_type,
           name: 'Lighting',
           api_name: 'lighting',
           genus_api_name: 'lighting')
  end
  let!(:led) do
    create(:structure_type,
           name: 'Led',
           api_name: 'led',
           genus_api_name: 'lighting')
  end

  let!(:blender) do
    create(:structure_type, name: 'Blender', api_name: 'blender')
  end

  let!(:measure1) do
    create(:measure,
           name: 'Replace lighting',
           api_name: 'lighting')
  end

  let!(:measure2) do
    create(:measure,
           name: 'Replace blender',
           api_name: 'replace_blender')
  end

  before do
    create(:structure_type,
           name: 'Incandescent',
           api_name: 'incandescent',
           genus_api_name: 'lighting')

    signin_as(user)
    set_up_audit_report(
      user: user,
      measure_selections: [
        { measure: measure1 },
        { measure: measure2 }
      ],
      structures: [
        { id: SecureRandom.uuid,
          name: 'White House',
          structure_type: { name: 'Building', api_name: 'building' },
          n_structures: 1,
          sample_group_id: nil,
          field_values: {},
          wegowise_id: 12_345,
          substructures: [
            { id: SecureRandom.uuid,
              name: 'Hallway lights',
              structure_type: { name: 'LED', api_name: 'led' },
              n_structures: 4,
              sample_group_id: nil,
              field_values: {
                watts_per_lamp: {
                  name: 'Watts per lamp',
                  value: 3,
                  value_type: 'integer' }
              }
            },
            { id: SecureRandom.uuid,
              name: 'Kitchen lights',
              structure_type: { name: 'LED', api_name: 'led' },
              n_structures: 1,
              sample_group_id: 'foo',
              field_values: {
                lampshade_style: {
                  name: 'Lampshade Style',
                  value: 'frilly',
                  value_type: 'string' },
                watts_per_lamp: {
                  name: 'Watts per lamp',
                  value: 4,
                  value_type: 'integer' }
              }
            },
            { id: SecureRandom.uuid,
              name: 'Kitchen lights',
              structure_type: { name: 'LED', api_name: 'led' },
              n_structures: 1,
              sample_group_id: 'foo',
              field_values: {
                lampshade_style: {
                  name: 'Lampshade Style',
                  value: 'frilly',
                  value_type: 'string' },
                watts_per_lamp: {
                  name: 'Watts per lamp',
                  value: 6,
                  value_type: 'integer' }
              }
            }
          ]
        }
      ],
      sample_groups: [
        { id: 'foo',
          name: '1-Bedroom Apartments',
          parent_structure_id: SecureRandom.uuid,
          n_structures: 2 }
      ],
      audit_name: '123 Main St'
    )
  end

  scenario 'Adding a structure to a report in progress' do
    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'lighting',
        options: [
          'Hallway lights - White House (4 total)',
          'Kitchen lights - 1-Bedroom Apartments (2 total)',
          'New structure...'
        ])
      select_structure_option(
        'Hallway lights - White House', api_name: 'lighting')
      click_button 'Next'
    end

    within_structure_change_section('1 - Lighting') do
      within_original_structure_card do
        expect_structure_name_field('Hallway lights - White House')
        expect_structure_quantity_field('4')
        expect_structure_fields(
          watts_per_lamp: '3.0',
          lampshade_style: '')
      end

      within_proposed_structure_card do
        expect_structure_name_field('Hallway lights - White House')
        expect_structure_quantity_field('4')
        expect_structure_fields(
          watts_per_lamp: '3.0',
          lampshade_style: '')
      end
    end

    # Add another light
    expect(page).to_not have_content('Add a structure')
    click_new_structure_button
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'lighting',
        options: [
          'Hallway lights - White House (4 total)',
          'Kitchen lights - 1-Bedroom Apartments (2 total)',
          'New structure...'
        ])
      select_structure_option(
        'Kitchen lights - 1-Bedroom Apartments',
        api_name: 'lighting')
      click_button 'Next'
    end

    within_structure_change_section('2 - Lighting') do
      within_original_structure_card do
        expect_structure_name_field('Kitchen lights - 1-Bedroom Apartments')
        expect_structure_quantity_field('2')
        expect_structure_fields(
          watts_per_lamp: '5.0',
          lampshade_style: 'frilly')
      end

      within_proposed_structure_card do
        expect_structure_name_field('Kitchen lights - 1-Bedroom Apartments')
        expect_structure_quantity_field('2')
        expect_structure_fields(
          watts_per_lamp: '5.0',
          lampshade_style: 'frilly')
      end
    end

    # Remove lights
    within_structure_change_section('2 - Lighting') do
      click_delete_structure_change
    end
    expect(page).to_not have_content('2 - Lighting')
    within_structure_change_section('1 - Lighting') do
      click_delete_structure_change
    end
    expect(page).to have_content('Add a structure to get started.')

    # Try to add a structure that doesn't exist in Wegoaudit
    select_measure_tab(measure2.name)
    click_link 'Add a structure'
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'blender',
        options: [
          'New structure...'
        ])

      select_structure_option(
        'New structure...',
        api_name: 'blender')
      click_button 'Next'
    end

    within_structure_change_section('1 - Blender') do
      within_original_structure_card do
        expect_structure_name_field('Unnamed - Top level')
        expect_structure_fields(mix_setting: '')
      end

      within_proposed_structure_card do
        expect_structure_name_field('Unnamed - Top level')
        expect_structure_fields(mix_setting: '')
      end
    end
  end
end
