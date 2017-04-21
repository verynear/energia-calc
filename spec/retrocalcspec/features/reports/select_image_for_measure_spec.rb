require 'features_helper'

feature 'add structures to report', :js do
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
        lighting: [:watts_per_lamp, :bulb_type]
      }
    )
  end

  let!(:user) { create(:user) }
  let!(:structure_type1) do
    create(:structure_type, name: 'Lighting', api_name: 'lighting')
  end
  let!(:structure_type2) do
    create(:structure_type, name: 'Blender', api_name: 'blender')
  end

  let!(:measure1) do
    create(:measure,
           name: 'Replace lighting',
           api_name: 'replace_lighting')
  end

  let!(:measure2) do
    create(:measure,
           name: 'Replace blender',
           api_name: 'replace_blender')
  end

  before do
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
              structure_type: { name: 'Lighting', api_name: 'lighting' },
              n_structures: 4,
              sample_group_id: nil,
              photos: [
                { id: 'foo',
                  medium_url: 'photo1_medium_url',
                  thumb_url: 'photo1_thumb_url' }
              ],
              field_values: {
                watts_per_lamp: {
                  name: 'Watts per lamp',
                  value: 3,
                  value_type: 'integer' }
              }
            },
            { id: SecureRandom.uuid,
              name: 'Blender',
              structure_type: { name: 'Blender', api_name: 'blender' },
              n_structures: 1,
              sample_group_id: nil,
              field_values: {} },
            { id: SecureRandom.uuid,
              name: 'Kitchen lights',
              structure_type: { name: 'Lighting', api_name: 'lighting' },
              n_structures: 1,
              sample_group_id: nil,
              photos: [
                { id: 'bar',
                  medium_url: 'photo2_medium_url',
                  thumb_url: 'photo2_thumb_url' }
              ],
              field_values: {
                bulb_type: {
                  name: 'Lamp type',
                  value: 'LED',
                  value_type: 'string' }
              }
            }
          ]
        }
      ],
      sample_groups: [],
      photos: [
        { id: 'baz',
          medium_url: 'photo3_medium_url',
          thumb_url: 'photo3_thumb_url' }
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
          'Kitchen lights - White House',
          'New structure...'])
      select_structure_option(
        'Hallway lights - White House', api_name: 'lighting')
      click_button 'Next'
    end

    # See audit and structure images
    expect_measure_images 'photo1_thumb_url', 'photo3_thumb_url'
    expect_not_selected_image 'foo'
    expect_not_selected_image 'baz'

    select_image 'foo'
    expect_selected_image 'foo'

    # Add another light
    expect(page).to_not have_content('Add a structure')
    click_new_structure_button
    should_see_modal('Choose structure to replace') do
      expect_structure_options(
        api_name: 'lighting',
        options: [
          'Hallway lights - White House (4 total)',
          'Kitchen lights - White House',
          'New structure...'])
      select_structure_option(
        'Kitchen lights - White House',
        api_name: 'lighting')
      click_button 'Next'
    end

    # See image for newly added structure
    expect_measure_images 'photo1_thumb_url', 'photo2_thumb_url', 'photo3_thumb_url'
    expect_selected_image 'foo'

    select_image 'bar'
    expect_selected_image 'bar'

    # View another measure; selected image should not change
    select_measure_tab 'Replace blender'
    select_measure_tab 'Replace lighting'

    expect_measure_images 'photo1_thumb_url', 'photo2_thumb_url', 'photo3_thumb_url'
    expect_selected_image 'bar'

    select_image 'baz'
    expect_selected_image 'baz'

    # Reload page
    visit current_path
    expect_measure_images 'photo1_thumb_url', 'photo2_thumb_url', 'photo3_thumb_url'
    expect_selected_image 'baz'
  end
end
