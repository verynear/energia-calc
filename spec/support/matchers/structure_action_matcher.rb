RSpec::Matchers.define :have_structure_action do |expected|
  match do |actual|
    actual.all(:xpath, "//div/a[@data-tooltip='#{expected}']").any?
  end

  failure_message do |actual|
    "expected that a structure action '#{expected}' would be found"
  end

  failure_message_when_negated do |actual|
    "expected that a structure action '#{expected}' would not be found"
  end
end
