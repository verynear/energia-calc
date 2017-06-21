module Features
  module AuditReportSupport
    def add_new_structure(name, api_name)
      open_add_new_structure_modal
      should_see_modal('Choose structure to replace') do
        select_structure_option(
          name,
          api_name: api_name)
        click_button 'Next'
      end
    end

    def add_new_structures(options)
      open_add_new_structure_modal
      should_see_modal('Choose structure to replace') do
        options.each do |name, api_name|
          select_structure_option(
            name,
            api_name: api_name)
        end
        click_button 'Next'
      end
    end

    def click_delete_measure_button_and_confirm
      find('a.js-delete-measure-link').click
      accept_javascript_alert 'Are you sure you want to delete this measure?'
    end

    def click_delete_structure_change
      find('a.js-delete-structure-change').click
    end

    def click_new_report_button
      find('a.js-new-report-button').click
    end

    def click_new_structure_button
      find('a.js-add-structure-link').click
    end

    def click_new_template_button
      find('a.js-new-template-button').click
    end

    def click_structure_field_reset_link(api_name:)
      focus_field(api_name: api_name)
      find(reset_link_css(api_name: api_name)).click
    end

    def click_structure_name_field_reset_link
      focus_field(selector: structure_name_css)
      find(structure_name_reset_link_css).click
    end

    def create_report_template(name, markdown)
      click_link 'Manage templates'
      click_new_template_button
      fill_in 'report_template_name', with: name
      fill_in 'report_template_markdown', with: markdown
      click_button 'Save'

      # navigate to audit report
      click_link 'All reports'
      click_link 'Edit measures'
    end

    def effective_structure_field_css(key)
      ".js-effective-structure-field[data-api_name='#{key}'] input"
    end

    def expect_active_measure(_measure, notes: nil)
      within_active_measure do
        if notes.present?
          expect(page).to have_content "Notes: #{notes}"
        else
          expect(page).to_not have_content 'Notes:'
        end
      end
    end

    def expect_audit_report_summary_values(**options)
      all('.totals__item', count: options.length)
      options.each do |key, value|
        field = find("div.totals__item[data-audit-report-calculation='#{key}']")
        field.find('.totals__value', text: value)
      end
    end

    def expect_audit_reports_table(*rows)
      headers = ['Name', 'Last edit']
      should_see_table(headers, rows)
      expect(page).to have_css('table')
    end

    def expect_audits_table(*rows)
      should_see_table(nil, rows)
      expect(page).to have_css('table')
    end

    def expect_effective_structure_field(key, value)
      css = effective_structure_field_css(key)
      expect(find(css).value).to eq(value)
    end

    def expect_fields(css: nil, **options)
      all(css, count: options.length)
      options.each do |key, value|
        field = find(field_css(api_name: key))
        expect(field.value).to eq(value.to_s)
      end
    end

    def expect_measure_images(*image_urls)
      all('.gallery__item', count: image_urls.length)

      image_urls.each do |image_url|
        expect(page).to have_css("img[src=#{image_url}]")
      end
    end

    def expect_measure_options(*names)
      expect(page)
        .to have_select('measure_selection[measure_id]', options: names)
    end

    def expect_measure_summary_values(**options)
      within_measure_summary do
        all('.js-calculated-values div.data', count: options.length)
        options.each do |key, value|
          field = find("div.data[data-measure-calculation='#{key}']")
          field.find('.data__value', text: value)
        end
      end
    end

    def expect_measure_tabs(*titles)
      all('.js-measure-tab', count: titles.length)
        .each_with_index do |section, index|
        expect(section).to have_content(titles[index])
      end
    end

    def expect_not_selected_image(image_id)
      radio = find_by_id(image_id)
      expect(radio).to_not be_checked
    end

    def expect_pdf_file_download
      wait_for_download
      expect(download).to match(/\.pdf\z/)
      File.open(download, 'rb') do |file|
        reader = PDF::Reader.new(file)
        yield reader.pages
      end
      clear_downloads
    end

    def expect_pdf_preview_to_match(*regexps)
      regexps.each do |regexp|
        find('.js-markdown-preview', text: Regexp.new(regexp))
      end
    end

    def expect_recommendations_table(*rows)
      should_see_table(
        [
          'Recommendation',
          'Estimated Cost',
          'Annual Dollar Savings',
          'Annual Usage Reduction',
          'Years to Payback',
          'Upgrade Lifetime (Years)',
          'SIR',
          'Potential Utility Rebate'
        ],
        rows
      )
    end

    def expect_selected_image(image_id)
      radio = find_by_id(image_id)
      expect(radio).to be_checked
    end

    def expect_selected_measure_tab(name)
      find('.js-measure-tab.active', text: name)
    end

    def expect_structure_change_title(name)
      expect(page).to have_css('.structure__title', text: name)
    end

    def expect_structure_fields(**options)
      expect_fields(css: 'input.js-structure-field', **options)
    end

    def expect_structure_name_field(value)
      field = page.find(structure_name_css)
      expect(field.value).to eq(value)
    end

    def expect_structure_options(api_name:, options:)
      expect(page)
        .to have_select(
          "structure_changes[#{api_name}]" \
          '[structure_wegoaudit_id]',
          options: options)
    end

    def expect_structure_quantity_field(value)
      field = page.find(structure_quantity_css)
      expect(field.value).to eq(value)
    end

    def field_css(api_name:)
      "input[data-api-name='#{api_name}']"
    end

    def fill_in_audit_report_field(api_name:, value:)
      selector = field_css(api_name: api_name)
      find(selector).set(value)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_in_audit_report_name_field(value:)
      selector = '.js-audit-report-name-field'
      find(selector).set(value)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_in_description_field(text)
      selector = '.js-description-field'
      find(selector).set(text)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_in_markdown_editor(text)
      field = find('.js-markdown-editor textarea')
      field.set('')
      field.native.send_keys text
    end

    def fill_in_measure_field(**options)
      within_measure_summary do
        fill_in_structure_field(options)
      end
    end

    def fill_in_structure_field(api_name:, value:)
      selector = field_css(api_name: api_name)
      find(selector).set(value)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_in_structure_name_field(value:)
      selector = structure_name_css
      find(selector).set(value)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_in_structure_quantity_field(value:)
      selector = structure_quantity_css
      find(selector).set(value)
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def fill_out_audit_level_fields(options)
      options.each do |key, value|
        fill_in_audit_report_field(api_name: key, value: value)
      end
    end

    def fill_out_measure_level_fields(options)
      options.each do |key, value|
        field = Field.by_api_name!(key)
        if field.value_type == 'picker'
          select_measure_field_option(api_name: key, value: value)
        else
          fill_in_measure_field(api_name: key, value: value)
        end
      end
    end

    def fill_out_structure_card(type, options)
      within_structure_card(type) do
        quantity = options[:quantity]
        fill_in_structure_quantity_field(value: quantity) if quantity
        options.each do |key, value|
          next if key == :quantity
          field = Field.by_api_name!(key)
          if field.value_type == 'picker'
            select_structure_field_option(api_name: key, value: value)
          else
            fill_in_structure_field(api_name: key, value: value)
          end
        end
      end
    end

    def fill_out_structure_cards(section_name, existing: {}, proposed: {})
      within_structure_change_section(section_name) do
        fill_out_structure_card(:original, existing)
        fill_out_structure_card(:proposed, proposed)
      end
    end

    def focus_field(api_name: nil, selector: nil)
      selector ||= field_css(api_name: api_name)
      page.execute_script(
        "$(\"#{selector}\").trigger('focus')"
      )
    end

    def open_add_new_structure_modal
      old_wait_time = Capybara.default_wait_time
      Capybara.default_wait_time = 0.1
      if page.has_content?('Add a structure')
        click_link 'Add a structure'
      else
        click_new_structure_button
      end
      Capybara.default_wait_time = old_wait_time
    end

    def reset_link_css(api_name:)
      "#{field_css(api_name: api_name)} + a.js-reset-value"
    end

    def select_image(image_id)
      choose(image_id)
    end

    def select_measure_field_option(**options)
      within_measure_summary do
        select_structure_field_option(options)
      end
    end

    def select_measure_tab(name)
      find('.js-measure-tab', text: name).click
    end

    def select_structure_field_option(api_name:, value:)
      selector = "select[data-api-name='#{api_name}']"
      find(selector).find("option[value='#{value}']").select_option
      page.execute_script("$(\"#{selector}\").trigger('change')")
    end

    def select_structure_option(option, api_name:)
      select(option,
             from: "structure_changes[#{api_name}]" \
             '[structure_wegoaudit_id]')
    end

    def select_template(name)
      select name, from: 'Select template'
    end

    def set_up_audit_report(**options)
      user = options.fetch(:user)
      audit_name = options.fetch(:audit_name)
      measure_selections = options.fetch(:measure_selections, [])
      structures = options.fetch(:structures, [])
      sample_groups = options.fetch(:sample_groups, [])
      photos = options.fetch(:photos, [])

      uuid = SecureRandom.uuid
      audits_json = [{ id: uuid,
                       name: audit_name,
                       date: '2015-05-01',
                       audit_type: 'Water Only' }]

      query = { wegowise_id: user.wegowise_id }
      stub_wegoaudit_request('/audits', query: query) do
        { audits: audits_json }
      end

      click_new_report_button

      measures_json = measure_selections.map do |measure_selection|
        { name: measure_selection[:measure].name,
          api_name: measure_selection[:measure].api_name,
          notes: measure_selection[:notes] }
      end

      should_see_modal('Create report') do
        stub_wegoaudit_request(
          "/audits/#{uuid}",
          query: { wegowise_id: user.wegowise_id }) do
            audit_payload(
              id: uuid,
              name: audit_name,
              date: '2015-05-01',
              audit_type: 'Water',
              structures: structures,
              sample_groups: sample_groups,
              photos: photos,
              measures: measures_json)
          end
        choose(audit_name)
        click_button 'Next'
      end
      expect(page).to have_content("Report based on \"#{audit_name}\"")
    end

    def set_up_audit_report_for_measures(measures, user:, substructures:)
      signin_as(user)

      substructures_array = substructures.map do |substructure|
        structure_type = substructure.fetch(:structure_type)
        field_values = substructure.fetch(:field_values, {})

        { id: SecureRandom.uuid,
          name: substructure.fetch(:name),
          structure_type: {
            name: structure_type.name,
            api_name: structure_type.api_name
          },
          field_values: field_values,
          n_structures: 1
        }
      end

      measures_array = measures.map { |measure| { measure: measure } }

      set_up_audit_report(
        user: user,
        measure_selections: measures_array,
        structures: [
          { id: SecureRandom.uuid,
            name: 'White House',
            structure_type: { name: 'Building', api_name: 'building' },
            field_values: {},
            n_structures: 1,
            wegowise_id: 12_345,
            substructures: substructures_array
          }
        ],
        audit_name: '123 Main St'
      )
    end

    def setup_lighting_measure
      create(:field,
             name: 'Type of lightbulb',
             api_name: 'type_of_lightbulb',
             value_type: 'picker',
             options: ['High-power', 'Low-power'])
      create(:field,
             name: 'Operating hours per day',
             api_name: 'operating_hours_per_day',
             value_type: 'decimal')
      create(:field,
             name: 'Total # of lamps',
             api_name: 'total_number_of_lamps',
             value_type: 'decimal')
      create(:field,
             name: 'Per lamp cost',
             api_name: 'per_lamp_cost',
             value_type: 'decimal')

      Field.unmemoize_all

      create(:measure, name: 'Replace lighting', api_name: 'replace_lighting')

      Kilomeasure.add_measure(
        'replace_lighting',
        data_types: ['electric'],
        inputs: [
          :operating_hours_per_day,
          :type_of_lightbulb,
          :total_number_of_lamps,
          :per_lamp_cost
        ],
        formulas: {
          base_kw:
            'total_number_of_lamps * watts_per_lamp',
          annual_electric_usage:
            'base_kw * operating_hours_per_day * 365',
          annual_operating_cost:
            'annual_electric_cost',
          retrofit_cost:
            'per_lamp_cost * total_number_of_lamps'
        },
        lookups: {
          watts_per_lamp: {
            input_name: 'type_of_lightbulb',
            lookup: {
              'Low-power' => 2,
              'High-power' => 3
            }
          }
        }
      )

      MeasureDefinitionsRegistry.add_definition(
        'replace_lighting',
        inputs: {
          measure: [
            :operating_hours_per_day
          ],
          lighting: [
            :type_of_lightbulb,
            :total_number_of_lamps,
            :per_lamp_cost
          ]
        },
        structures: {
          lighting: {
            multiple: true,
            fields: {
              per_lamp_cost: {
                proposed_only: true
              }
            },
            field_for_grouping: :bulb_type
          }
        }
      )
    end

    def should_not_see_structure_field_reset_link(api_name:)
      focus_field(api_name: api_name)
      expect(page).to_not have_css(reset_link_css(api_name: api_name))
    end

    def structure_name_css
      '.js-structure-name-field'
    end

    def structure_name_reset_link_css
      "#{structure_name_css} + " \
      'a.js-reset-value'
    end

    def structure_quantity_css
      '.js-structure-quantity-field'
    end

    def within_active_measure
      within('.js-active-content') do
        yield
      end
    end

    def within_measure_summary
      within('.js-measure-summary') do
        yield
      end
    end

    def within_original_structure_card
      within('.js-original-structure') do
        yield
      end
    end

    def within_pdf_preview
      within('.js-markdown-preview') do
        yield
      end
    end

    def within_proposed_structure_card
      within('.js-proposed-structure') do
        yield
      end
    end

    def within_structure_card(type)
      within(".js-#{type}-structure") do
        yield
      end
    end

    def within_structure_change_section(structure_name)
      within('.structure', text: structure_name) do
        expect_structure_change_title(structure_name)
        yield
      end
    end
  end
end
