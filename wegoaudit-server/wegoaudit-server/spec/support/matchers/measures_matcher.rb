RSpec::Matchers.define :have_selected_measure do |expected|
  match do |actual|
    actual.has_selector?(:checkbox, expected, checked: true)
  end

  failure_message do |actual|
    "expected that a measure '#{expected}' would be selected"
  end

  failure_message_when_negated do |actual|
    "expected that a measure '#{expected}' would not be selected"
  end
end

RSpec::Matchers.define :have_deselected_measure do |expected|
  match do |actual|
    actual.has_selector?(:checkbox, expected, unchecked: true)
  end

  failure_message do |actual|
    "expected that a measure '#{expected}' would not be selected"
  end

  failure_message_when_negated do |actual|
    "expected that a measure '#{expected}' would be selected"
  end
end
