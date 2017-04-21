module Features
  module WebSupport
    def accept_javascript_alert(text = nil)
      alert = page.driver.browser.switch_to.alert
      wait { expect(alert.text).to eq text } if text.present?
      alert.accept
    end

    # see http://elementalselenium.com/tips/39-drag-and-drop for example
    def drag_and_drop(source, target)
      js_filepath = File.dirname(__FILE__) + '/drag_and_drop_helper.js'
      dnd_javascript = File.read(js_filepath)
      action_javascript =
        "; $(\"#{source}\").simulateDragDrop({ dropTarget: $(\"#{target}\") })"
      page.execute_script(dnd_javascript + action_javascript)
    end

    def wait(&block)
      20.times do
        begin
          block.call
          return
        rescue RSpec::Expectations::ExpectationNotMetError,
               Selenium::WebDriver::Error::ElementNotVisibleError
          sleep 0.1
        end
      end
      block.call
    end
  end
end
