RSpec::Matchers.define :have_audit_row do |expected|
  match do |actual|
    actual.all(:xpath, "//tr[td[contains(.,'#{expected}')]]").any?
  end

  failure_message do |actual|
    "expected that a table row for audit '#{expected}' would be found"
  end

  failure_message_when_negated do |actual|
    "expected that a table row for audit '#{expected}' would not be found"
  end
end
