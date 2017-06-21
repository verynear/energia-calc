require 'rails_helper'

Dir[Rails.root.join('spec/features/support/**/*.rb')].each do |f|
  next if f =~ /common\.rb/
  require f
end
require_relative 'features/support/common'

require 'capybara/rspec'

Capybara.ignore_hidden_elements = true
Capybara.default_wait_time = 10

module RetrocalcSpecs
  DOWNLOAD_PATH = Dir.mktmpdir
end

require 'selenium-webdriver'
require 'selenium/webdriver/remote/http/curb'

profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.download.dir'] = RetrocalcSpecs::DOWNLOAD_PATH
profile['browser.download.folderList'] = 2

# Disable in-page PDF viewer
profile['pdfjs.disabled'] = true
profile['pdfjs.previousHandler.alwaysAskBeforeHandling'] = false

# Do not ask what to do with an unknown MIME type
profile['browser.helperApps.alwaysAsk.force'] = false

profile['browser.download.manager.showWhenStarting'] = false

# Save to disk without asking what to use to open the file
profile['browser.helperApps.neverAsk.saveToDisk'] =
  'text/csv,application/csv,application/zip,application/pdf'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    profile: profile,
    http_client: Selenium::WebDriver::Remote::Http::Curb.new)
end
