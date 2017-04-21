RSpec::Matchers.define :have_structure_row do |expected|
  match do |actual|
    actual.all(:css, '.structure-row', text: expected).any?
  end

  failure_message do |actual|
    "expected that a row for '#{expected}' would be found"
  end

  failure_message_when_negated do |actual|
    "expected that a row for '#{expected}' would not be found"
  end
end
