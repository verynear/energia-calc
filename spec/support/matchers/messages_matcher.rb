RSpec::Matchers.define :have_notice do |expected|
  match do |actual|
    actual.all(".flash-notice", text: expected).any?
  end

  failure_message do |actual|
    %{expected that a success message "#{expected}" would be found}
  end

  failure_message_when_negated do |actual|
    %{expected that a success message "#{expected}" would not be found}
  end
end
