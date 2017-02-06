RSpec::Matchers.define :have_structure_type_action do |expected|
  match do |actual|
    actual.all(:css, '.section-title__action', text: expected).any?
  end

  failure_message do |actual|
    "expected that a structure type action '#{expected}' would be found"
  end

  failure_message_when_negated do |actual|
    "expected that a structure type action '#{expected}' would not be found"
  end
end
