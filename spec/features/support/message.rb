module Features
  module MessageSupport
    def expect_alert_notice(message)
      expect(page).to have_css('.flash_alert', text: message)
    end

    def expect_error_text(message)
      expect(page).to have_css('.error__msg', text: message)
    end
  end
end
