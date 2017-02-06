RSpec::Matchers.define :have_grouping do |expected|
  match do |actual|
    actual.has_css?('fieldset .section-title', text: expected)
  end

  failure_message do |actual|
    "expected that a grouping '#{expected}' would be found"
  end

  failure_message_when_negated do |actual|
    "expected that a grouping '#{expected}' would not be found"
  end
end
