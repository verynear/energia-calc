module Helpers
  module Navigation
    def accept_js_alert
      page.driver.browser.switch_to.alert.accept
    end

    def click_audit(name, action: nil)
      if action.nil?
        click_link name
      else
        # Find and click the row action for the desired table row
        table_row_path = "//tr[td[contains(.,'#{name}')]]"
        action_path ="td/a[@data-tooltip='#{action}']"
        find(:xpath, "#{table_row_path}").hover
        find(:xpath, "#{table_row_path}/#{action_path}").click
      end
    end

    def click_crumb_link(text)
      find(:css, '.crumbs a', text: text).click
    end

    def click_delete_confirmation(action_text)
      sleep 0.1
      within('.js-delete-query.in') do
        click_link(action_text)
      end
    end

    def click_section_tab(name)
      page.find('.tab-menu a', text: name).click
    end

    def click_structure_type(name, action: nil)
      if action.nil?
        page.find('.section-title a', text: name).click
      else
        within('.section-title', text: name) do
          find('.section-title__action', text: action).click
        end
      end
    end

    def click_structure_row(name, action: nil)
      if action.nil?
        page.find('.structure-row a', text: name).click
      else
        find('.structure-row', text: name).hover
        within('.structure-row', text: name) do
          find(:xpath, "//div/a[@data-tooltip='#{action}']").click
        end
      end
    end
  end
end
