module Features
  module HtmlSupport
    def cached_node(selenium_element)
      # When we use selenium-webdriver with capybara, every finder request
      # results in another browser interaction, which is incredibly slow. We
      # prefer to deal with a cached result. To do that, we convert the
      # HTML to a Nokogiri element, and then create a new Capybara node
      # from that.
      html = selenium_element.native.attribute('innerHTML')
      nokogiri_el = Nokogiri::HTML(html)
      Capybara::Node::Simple.new(nokogiri_el)
    end

    def should_see_table(headers, rows = nil, matcher = 'table')
      # Use uncached selectors to verify that the table is on the page
      # with the correct number of rows, so that we can properly wait
      # for the results of AJAX requests.
      within(matcher) do
        if rows
          within('tbody') do
            expect(page)
              .to have_selector('tr', count: rows.length),
                  "expected #{rows.length} rows, got #{all('tr').length}"
          end
        end
      end

      # For the rest of this method, we'll be dealing with a cached
      # version of the table.
      table = cached_node(page.find(matcher))

      # Verify headers are accurate
      if headers
        actual_headings = table.all('thead tr:first-child th')
        headers.each_with_index do |desired_heading, ind|
          expect(actual_headings[ind])
            .to match_text(desired_heading)
            .in_context(" in header row, column #{ind}")
        end
      end

      if rows
        actual_rows = table.all('tbody tr')

        rows.each_with_index do |desired_row, row_index|
          actual_row_items = actual_rows[row_index].all('th, td')

          # Delete items that are marked as ---, which indicates
          # it is part of the previous row with multiple row-span
          desired_row.delete_if { |row_item| row_item == '---' }
          desired_row.each_with_index do |desired_row_item, ind|
            expect(actual_row_items[ind])
              .to match_text(desired_row_item)
              .in_context(" in tbody row #{row_index}, column #{ind}")
          end
        end
      end
    end
  end
end
