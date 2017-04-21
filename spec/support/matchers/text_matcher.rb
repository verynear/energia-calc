RSpec::Matchers.define :match_text do |expected|
  match do |actual|
    expected = format_expected_string(expected)

    @actual_text = nokogiri_element(actual).nice_inner_text_including_inputs

    if expected.is_a? Regexp
      expect(@actual_text).to match(expected)
    else
      expect(@actual_text).to eq(expected)
    end
  end

  failure_message do
    %(expected "#{@actual_text}" to match text #{expected.inspect} #{@context})
      .squish
  end

  chain(:in_context) { |context| @context = context }

  def format_expected_string(string)
    return string if string.is_a?(Regexp)

    string.to_s.tap do |str|
      str.gsub!("''", '"')
      str.gsub!(/\n/, ' ')
      str.squish!
    end
  end

  def nokogiri_element(capybara_node)
    native = capybara_node.native

    if native.is_a? Selenium::WebDriver::Element
      Nokogiri::HTML.parse(native.attribute('innerHTML'))
    elsif native.is_a? Nokogiri::XML::Element
      native
    else
      raise ArgumentError
    end
  end
end
